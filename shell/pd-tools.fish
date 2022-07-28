if status is-interactive
    function pd:tail -a file lines -d "tails a file"
        set -q lines[1]; or set lines 1000
        sudo tail -f -n $lines $file
    end
    function pd:svc:q -a name -d "Gets the status of a systemd service"
        sudo systemctl status $name
    end
    function pd:svc:exists -a service -d "Checks if a systemd service exists"
        test (systemctl list-unit-files $service'*' | wc -l) -gt 3
    end
    function pd:nginx:re -d "Refreshes nginx"
        sudo nginx -t and nginx -s reload
    end
    function pd:svc:refresh -d "Reloads the systemd daemon"
        sudo systemctl daemon-reload
    end
    function pd:svc:j -a name lines -d "Reads the journal entries for a systemd service"
        set -q lines[1]; or set lines 1000
        sudo journalctl -u $name -n $lines
    end
    function pd:setup -d "Perdido setup runner"
        sudo /opt/perdido/setup $argv
    end
    function pd:sweep -d "Calls a manual sweep of [ARGS]"
        sudo -u rtorrent /opt/perdido/commands/sweeper $argv
    end

    # Log files
    begin
        function pd:def:tail -a name path -d "Defines a function to tail a log"
            if not test -f $path
                echo PATH $path DOES NOT EXIST
                return 1
            end
            echo "
            function pd:log:$name -a lines -d 'Tail log file for $name'
                pd:tail $path \$lines
            end
            " | source
        end

        # System
        pd:def:tail auth /var/log/auth.log
        pd:def:tail sys /var/log/syslog

        # Nginx
        pd:def:tail nginx:access /var/log/nginx/access.log
        pd:def:tail nginx:error /var/log/nginx/error.log
        pd:def:tail nginx:modsec /var/log/modsec_audit.log

        # Services
        pd:def:tail php /var/log/php7.4-fpm.log
        pd:def:tail fail2ban /var/log/fail2ban.log
        pd:def:tail rutorrent /var/rutorrent/rutorrent.log
        pd:def:tail jellyfin /var/jellyfin/log/log_(date +%Y%m%d).log
        pd:def:tail filebrowser /var/filebrowser/filebrowser.log
        # Sweeper
        pd:def:tail sweeper /var/sweeper/logs/sweeper.log
    end
    begin
        function pd:def:service -a name -d "Defines a command to get info about a service"
            if not pd:svc:exists $name
                echo Invalid service $name
                return 1
            end
            echo "
             function pd:svc:q:$name -d 'Gets status info about $name'
                pd:svc:q $name
            end
            function pd:svc:j:$name -a lines -d 'Gets the journal for $name'
                pd:svc:j $name \$lines
            end
            " | source

        end

        pd:def:service nginx
        pd:def:service jellyfin
        pd:def:service rtorrent
        pd:def:service fail2ban
        pd:def:service filebrowser
        pd:def:service php7.4-fpm

    end
end
