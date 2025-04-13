# Debugging Terraform #
1. Terrafrm has detailed logs that can be enabled by setting the TF_LOG environment variable to any value.

2. To have persstant logs, need to set TF_LOG_PATH forefully apend all the logs to a specific file, when logging is enabled.

3. we can set TF_LOG to one of the log levels (in order of decreasing verbosity)
    ** LOG - LEVELS **
    1. TRACE
    2. DEBUG
    3. INFO
    4. WARN
    5. ERROR

4. To start with, lets take "INFO" level to enable log following command need to be issued
    $ export TF_LOG = info
