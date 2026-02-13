# ofhelper: Working with and on DNAnexus's Our Future Health Trusted Research Environment

DNAnexus provides Trusted Research Environments (TREs) for several large
population-based cohort studies, like the UK Biobank (UKB) and Our
Future Health (OFH). For working on and with their TRE, they provide the
\`dx\` Python utility for interacting with cloud environment. When
working within R, this requires switching to a shell or wrapping calls
in \`system2()\` or similar. This package provides several convenience
wrappers to do this for you. Additionally, it enables submitting jobs
with arbitrary R codes from your local session. Finally, several default
workflows for OFH are provided.

## Author

**Maintainer**: Carl Beuchel <carl.beuchel@charite.de>
([ORCID](https://orcid.org/0000-0003-3437-9963))
