# Monitoring

For now, monitoring will be done through basic tools, but the goal is to move to a more advanced monitoring stack.

## Tools
1. **htop** - for process monitoring
2. **systemctl** - for checking service statuses

## Alerts
- Use **systemd timers** to automate checking logs or processes.
- Set up basic email alerts (later on, possibly Prometheus + Grafana).

### Check system health:
htop
systemctl status syncthing
