
#!/bin/bash

id=`xinput list | grep -E "Touchpad|Trackpad" | cut -d'=' -f2 | cut -d'[' -f1`
natural_scrolling_id=`xinput list-props $id | \
                      grep "Natural Scrolling Enabled (" \
                      | cut -d'(' -f2 | cut -d')' -f1`
tap_to_click_id=`xinput list-props $id | \
                          grep "Tapping Enabled (" \
                                                | cut -d'(' -f2 | cut -d')' -f1`

xinput --set-prop $id $natural_scrolling_id 1
xinput --set-prop $id $tap_to_click_id 1
