# Storing as luks key on a usb drive

Based on these [instructions](https://askubuntu.com/questions/59487/how-to-configure-lvm-luks-to-autodecrypt-partition)

`/etc/crypttab`:

```console
cryptdata UUID=e25a90eb-47d7-44da-8e0b-d695e2b4a6dc /dev/disk/by-label/keys:/luks-keys/cryptdata_secret_key luks,keyscript=/lib/cryptsetup/scripts/unlock_from_device
seagate_crypt UUID=3466bf26-59db-471f-85f9-610fd8807c1a /home/twhitney/.local/etc/luks-keys/seagate_secret_key luks
wd_crypt UUID=a0ac0856-8d02-4c96-bc6d-4d990e6ef67f /home/twhitney/.local/etc/luks-keys/wd_secret_key luks
```

`/lib/cryptsetup/script/unlock_from_device`:

```bash
#!/bin/sh

ask_for_password () {
    cryptkey="Enter passphrase: "
    if [ -x /bin/plymouth ] && plymouth --ping; then
        cryptkeyscript="plymouth ask-for-password --prompt"
        cryptkey=$(printf "$cryptkey")
    else
        cryptkeyscript="/lib/cryptsetup/askpass"
    fi
    $cryptkeyscript "$cryptkey"
}

device=$(echo $1 | cut -d: -f1)
filepath=$(echo $1 | cut -d: -f2)

# Ask for password if device doesn't exist
if [ ! -b $device ]; then
    ask_for_password
    exit
fi

mkdir /tmp/auto_unlocker
mount $device /tmp/auto_unlocker

# Again ask for password if device exist but file doesn't exist
if [ ! -e /tmp/auto_unlocker$filepath ]; then
    ask_for_password
else
    cat /tmp/auto_unlocker$filepath
fi

umount /tmp/auto_unlocker
```
