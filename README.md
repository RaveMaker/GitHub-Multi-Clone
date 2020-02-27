GitHub-Multi-Clone
==================

Clone all User or Organization repositories from GitHub.

- Supports both GIT and HTTPS clone.
- Supports cloning of all repos even if higher then 100 (GitHub api limit).

### Installation

1. Clone this script from github or copy the files manually to your preferred directory.

2. Create settings.cfg from settings.cfg.example and change:

```
# Where to Clone
DEST_FOLDER="/d/Dev/repos/TEST"

# User or Organization Name from GitHub url
GIT_NAME="RaveMaker"

# Select GitHub account type - User=1 Organization=2
USER_ORG="1"

# Select repo clone mode - GIT=1 HTTPS=2
GIT_HTTPS="1"

# Debug mode: set to "false" to enable cloning
DEBUG_MODE="true"

```

Author: [RaveMaker][RaveMaker].

[RaveMaker]: http://ravemaker.net
