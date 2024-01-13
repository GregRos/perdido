# Quick shortcuts for relevant commands via SSH
if status is-interactive
    function pd.tail -a file lines -d "tails a file"
        set -q lines[1]; or set lines 1000
        sudo tail -f -n $lines $file
    end
    function pd.svc.status -a name -d "Gets the status of a systemd service"
        sudo systemctl status $name
    end
    function pd.svc.start -a name -d "Starts a systemd service"
        sudo systemctl start $name
    end
    function pd.svc.stop -a name -d "Starts a systemd service"
        sudo systemctl stop $name
    end
    function pd.svc.exists -a service -d "Checks if a systemd service exists"
        test (systemctl list-unit-files $service'*' | wc -l) -gt 3
    end
    function pd.svc.restart -a service -d "Restarts a systemd service"
        sudo systemctl daemon-reload
        sudo systemctl restart $service
    end
    function pd.nginx.reload -d "Refreshes nginx"
        sudo systemctl start nginx && nginx -t && sudo nginx -s reload
    end
    function pd.svc.reload -d "Reloads the systemd daemon"
        sudo systemctl daemon-reload
    end
    function pd.nginx.stop -d "Stops nginx"
        sudo nginx -s stop
    end
    function pd.svc.journal -a name lines -d "Reads the journal entries for a systemd service"
        set -q lines[1]; or set lines 1000
        sudo journalctl -u $name -n $lines
    end
    function pd.setup -d "Perdido setup runner"
        sudo bash -c "cd /opt/perdido; ./setup $argv"
    end
    function pd.sweep -d "Calls a manual sweep of target root"
        sudo -u rtorrent /opt/perdido/commands/sweeper $argv
    end
    function pd.erase -d "Erases all hardlinks of a file in libraries etc"
        /opt/perdido/commands/delete-media $argv
    end
    function pd.fix.owners -d "Fixes owners for all known folders"
        pd.setup run fix-permissions
    end
    # Log files
    begin
        function pd.def.tail -a name path -d "Defines a function to tail a log"
            if not test -f $path
                echo PATH $path DOES NOT EXIST
                return 1
            end
            # Defines dynamic `pd.X.log`
            echo "
            function pd.$name.log -a lines -d 'Tail log file for $name, "(basename $path)"'
                pd.tail $path \$lines
            end
            " | source
        end

        # System
        pd.def.tail auth /var/log/auth.log
        pd.def.tail sys /var/log/syslog

        # Nginx
        pd.def.tail nginx.access /var/log/nginx/access.log
        pd.def.tail nginx.error /var/log/nginx/error.log
        pd.def.tail nginx.scgi /var/log/nginx/scgi.log
        pd.def.tail nginx.modsec /var/log/modsec_audit.log

        # Services
        pd.def.tail php /var/log/php7.4-fpm.log
        pd.def.tail fail2ban /var/log/fail2ban.log
        pd.def.tail rutorrent /var/rutorrent/rutorrent.log
        pd.def.tail jellyfin /var/jellyfin/log/log_(date +%Y%m%d).log
        pd.def.tail filebrowser /var/filebrowser/filebrowser.log
        pd.def.tail transmission /var/log/transmission/transmission.log
        # Sweeper
        pd.def.tail sweeper /var/sweeper/logs/sweeper.log
    end
    begin
        function pd.def.service -a name -a code -d "Defines a command to get info about a service"
            set -q code; or set code $name
            if not pd.svc.exists $name
                echo Invalid service $name
                return 1
            end
            # Defines dynamic:
            # pd.$name.status
            # pd.$name.jrnl
            # pd.$name.restart
            echo "
             function pd.$code.status -d 'Gets service status for $name'
                pd.svc.status $name
            end
            function pd.$code.jrnl -a lines -d 'Gets journal for $name'
                pd.svc.journal $name \$lines
            end
            function pd.$code.restart -d 'Restarts the $name service.'
                pd.svc.restart $name
            end
            function pd.$code.stop -d 'Stops the $name service.'
                pd.svc.stop $name
            end
            function pd.$code.start -d 'Starts the $name service.'
                pd.svc.start $name
            end
            " | source

        end

        pd.def.service nginx
        pd.def.service jellyfin
        pd.def.service rtorrent
        pd.def.service fail2ban
        pd.def.service filebrowser
        pd.def.service php7.4-fpm
        pd.def.service log-viewer
        pd.def.service syncthing
        pd.def.service iperf
        pd.def.service smbd
        pd.def.service vsftpd
        pd.def.service sonarr
        pd.def.service radarr
        pd.def.service jackett
        pd.def.service prowlarr
        pd.def.service php7.4-fpm
        pd.def.service transmission-daemon transmission
    end
end
