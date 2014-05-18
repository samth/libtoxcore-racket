libtoxcore-racket
=================

libtoxcore-racket is a Racket wrapper to the Tox library aiming to be a Racket
package that has an Object-Oriented approach to programming for Tox. This
package also allows direct access to the functions through the basic wrapper,
but this is less cool.

## Installation
* If you are using Racket version 6, open a terminal and enter the following:
```raco pkg install github://github.com/lehitoskin/libtoxcore-racket/master```

* If you are using Racket version 5.3.x (most likely), run the following:
```raco pkg install github://github.com/lehitoskin/libtoxcore-racket/racket5.3```

Racket's raco package manager will do the rest. Alternatively, you may install
the package by copying the github link and pasting it into DrRacket's "Install
Package" tool.

## Implemented API Functions
* Below is a list of the API functions that have been implemented, in
alphabetical order:

```
tox_add_friend
tox_add_friend_norequest
tox_add_groupchat
tox_bootstrap_from_address
tox_bootstrap_from_ip
tox_callback_connection_status
tox_callback_file_control
tox_callback_file_data
tox_callback_file_send_request
tox_callback_friend_action
tox_callback_friend_message
tox_callback_friend_request
tox_callback_group_action
tox_callback_group_invite
tox_callback_group_message
tox_callback_group_namelist_change
tox_callback_name_change
tox_callback_read_receipt
tox_callback_status_message
tox_callback_typing_change
tox_callback_user_status
tox_count_chatlist
tox_count_friendlist
tox_del_friend
tox_del_groupchat
tox_do
tox_file_data_remaining
tox_file_data_size
tox_file_send_control
tox_file_send_data
tox_friend_exists
tox_get_address
tox_get_chatlist
tox_get_client_id
tox_get_friend_connection_status
tox_get_friendlist
tox_get_friend_number
tox_get_is_typing
tox_get_last_online
tox_get_name
tox_get_name_size
tox_get_nospam
tox_get_num_online_friends
tox_get_self_name
tox_get_self_name_size
tox_get_self_status_message
tox_get_self_status_message_size
tox_get_self_user_status
tox_get_status_message
tox_get_status_message_size
tox_get_user_status
tox_group_action_send
tox_group_get_names
tox_group_message_send
tox_group_number_peers
tox_group_peername
tox_invite_friend
tox_isconnected
tox_join_groupchat
tox_kill
tox_load
tox_new
tox_new_file_sender
tox_save
tox_send_action
tox_send_action_withid
tox_send_message
tox_send_message_withid
tox_set_name
tox_set_nospam
tox_set_sends_receipts
tox_set_status_message
tox_set_user_is_typing
tox_set_user_status
tox_size
tox_wait_cleanup
tox_wait_data_size
tox_wait_execute
tox_wait_prepare
```
