#!/bin/bash
# Rsyslog and auditd client configuration (for centralized Rsyslog achitecture)

yum install -y audit audit-libs

# auditd configuration
echo '-a exit,always -F arch=b64 -S execve -k root-commands' >> /etc/audit/rules.d/audit.rules
echo '-a exit,always -F arch=b32 -S execve -k root-commands' >> /etc/audit/rules.d/audit.rules
service auditd restart
auditctl -l


# rsyslog configuration
echo 'Configuring rsyslog...'
echo '# Logs to be sent to central rsyslog (auditd logs)' >> /etc/rsyslog.conf
echo '$ModLoad imfile' >> /etc/rsyslog.conf
echo '$InputFileName /var/log/audit/audit.log' >> /etc/rsyslog.conf
echo '$InputFileTag tag_audit_log:' >> /etc/rsyslog.conf
echo '$InputFileStateFile audit_log' >> /etc/rsyslog.conf
echo '$InputFileFileSeverity info' >> /etc/rsyslog.conf
echo '$InputFileFileFacility local6' >> /etc/rsyslog.conf
echo '$InputRunFileMonitor' >> /etc/rsyslog.conf
echo 'local6.* @<ip_rsyslog_server>:514' >> /etc/rsyslog.conf
echo 'rsyslog configured to send audit logs to rsyslog central server'
echo 'restarting resyslog to apply the new configuration...'

systemctl restart rsyslog
systemctl status rsyslog

exit
