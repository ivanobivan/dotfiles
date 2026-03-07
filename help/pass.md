gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
pass init <key>

export
gpg --export-secret-keys \*\*\* > private.key

import
gpg --import private.key
