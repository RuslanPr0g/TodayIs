# Setup

## Prerequisites
- Linux with systemd
- Git configured with SSH access to the remote

## Install

```bash
git clone git@github.com:RuslanPr0g/TodayIs.git
cd TodayIs
chmod +x update.sh
```

## Autorun on login

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/todayis.service << EOF
[Unit]
Description=TodayIs
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$(pwd)/update.sh
StandardOutput=append:$(pwd)/script.log
StandardError=append:$(pwd)/script.log

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable todayis.service
```

The service runs once per login after network is available. Logs go to `script.log`.
