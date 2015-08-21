# docker-nginx-php-fpm

[![](https://badge.imagelayers.io/sys42/docker-nginx-php-fpm:latest.svg)](https://imagelayers.io/?images=sys42/docker-nginx-php-fpm:latest 'Get your own badge on imagelayers.io')

NGINX and PHP running in a Docker Container.

**Special Features:**
  
  * logforwarding of nginx and php to stdout 
  * see features of base image (pid 1 reaping problem, dynamic user remapping ...)

I'm completely aware that it is somewhat against the Docker philosophy to run both parts in a single container. But what would be the benefits of splitting them apart? 

  * Plugging in a different brand of webserver? In practice there is no different brand which can compete performance and memory wise.
  * Load balance multiple php-fpm instances behind a single webserver? Make no sense to me. If we'll need more scale than a single host can provide, than we'll properly need to scale nginx, too, and then loadbalance the whole shebang with ha-proxy.
  * Single matter of concern? For me it's a single concern: I cannot think of php without a webserver. That's like awk or sed without a surrounding shell. Php is just a kind of plugin, that extends the usability of the webserver.
  * Additionally: with just the phpinfo page as payload the memory consumption of the combined solution is about 30mb. So nothing to bother about memory-wise. If one of the parts bug out, start a new bundle.

**The benefits of combining both?**

Ease of use. No hassles with orchestration. You just need a single instance? Spin it up with one docker command including port mapping(s) and binding to an external document root and you are done. Tear it down with one command. After all it's just a black box. It's only a minor technical detail that there are more than one process involved. You wouldn't separate the nginx master from it's workers either, would you? Php is only a different kind of worker.

### Possible improvements:

  1. Hardening the embedded configs of nginx and php (actually it's more or less just the standard config)
  2. Handling logs by forwarding it to stdout isn't that useful, because the logs of all different parts get mixed up. For a more production ready system logs should be streamed off to a logserver.
  3. Metrics and health: instrumenting just the host may not be enough to detect or investigate any problems. System related metrics should be streamed off periodically to a monitoring system.

Points (2) and (3) can be further combined by a system-wide messaging system. It shouldn't concern the single container who is interested in its logs or metrics. Just tag everything correctly (different topics or queues or whatever) and push it into the messaging system. 

[Apache Kafka](http://kafka.apache.org/) comes to my mind ...


---------

For generic usage informations please examine [the README file of the base image](https://github.com/sys42/docker-base).

