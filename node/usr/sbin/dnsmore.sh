#!/bin/sh
# Configure dnsmasq to query the DNS servers named in /etc/dnsmore.conf.
# This script is usually in /usr/sbin.
if [ "$1" = "-v" ]; then
    VERBOSE=true
    shift
else
    VERBOSE=
fi
CONF_FILE="${1:-/etc/dnsmore.conf}"
START="# { $0 $CONF_FILE"
FINISH="# } $0 $CONF_FILE"

# Find the first resolv-file setting in the dnsmasq configuration file:
RESOLV_FILE=$(\
    grep "^[ \t]*resolv-file[ \t]*=" /etc/dnsmasq.conf\
    | head -1\
    | sed -e "s/^[ \t]*resolv-file[ \t]*=[ \t]*//" -e "s/[ \t]*$//"\
    )
if [ "$RESOLV_FILE" = "" ]; then
    echo 1>&2 "no resolv-file in /etc/dnsmasq.conf"
    exit 1
fi
[ "$VERBOSE" ] && echo "resolv-file=$RESOLV_FILE"

NEW_RESOLV_FILE=$(mktemp) || exit $?
# Remove the old DNS servers:
awk '{
  if ($0 == "'"$FINISH"'") skipping = 0
  if (!skipping) print
  if ($0 == "'"$START"'") skipping = 1
}
' "$RESOLV_FILE" > "$NEW_RESOLV_FILE" || exit $?
if [ "$VERBOSE" ]; then
    echo "$NEW_RESOLV_FILE ="
    cat "$NEW_RESOLV_FILE"
    echo # blank line
fi

# Find the addresses of the new DNS servers:
SERVERS=""
for NAME in $(grep -v "^[ \t]*#" "$CONF_FILE"); do
    [ "$VERBOSE" ] && echo "NAME=$NAME"
    for SERVER in $(nslookup $NAME\
        | sed -n -e '/^Name[^:]*:/,$ p'\
        | sed -n -e 's/^Address[^:]*:[ \t]*//p'\
        ); do
        [ "$VERBOSE" ] && echo "SERVER=$SERVER"
        # But not servers that are configured elsewhere in RESOLV_FILE:
        grep "^[ \t]*nameserver[ \t][ \t]*$SERVER""[ \t]*$"\
             "$NEW_RESOLV_FILE" > /dev/null\
            || SERVERS="$SERVERS $SERVER"
    done
done
[ "$VERBOSE" ] && echo "SERVERS=$SERVERS"

# Insert the new DNS servers' addresses into NEW_RESOLV_FILE:
if [ "$SERVERS" ]; then
    HEAD=$(grep -n "^$START$" "$RESOLV_FILE" | head -1 | sed -e 's/:.*//')
    if [ "$HEAD" ]; then
        head -$HEAD "$RESOLV_FILE" > "$NEW_RESOLV_FILE" || exit $?
    else
        # Insert them at the beginning.
        echo "$START" > "$NEW_RESOLV_FILE" || exit $?
    fi
    for SERVER in $SERVERS; do
        echo "nameserver $SERVER" >> "$NEW_RESOLV_FILE" || exit $?
    done
    if [ "$HEAD" ]; then
        TAIL=$(grep -n "^$FINISH$" "$RESOLV_FILE" | tail -1 | sed -e 's/:.*//')
        if [ "$TAIL" ]; then
            tail -n +$TAIL "$RESOLV_FILE" >> "$NEW_RESOLV_FILE" || exit $?
        else
            echo "$FINISH" >> "$NEW_RESOLV_FILE" || exit $?
        fi
    else
        echo "$FINISH" >> "$NEW_RESOLV_FILE" || exit $?
        cat "$RESOLV_FILE" >> "$NEW_RESOLV_FILE" || exit $?
    fi
fi
if cmp -s "$NEW_RESOLV_FILE" "$RESOLV_FILE"; then
    [ "$VERBOSE" ] && echo "no change"
    rm -f "$NEW_RESOLV_FILE"
else
    # Install the new resolv-file:
    if [ "$VERBOSE" ]; then
        echo "$RESOLV_FILE ="
        cat "$NEW_RESOLV_FILE"
        echo # blank line
    fi
    mv "$NEW_RESOLV_FILE" "$RESOLV_FILE" || exit $?
fi
