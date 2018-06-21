# push blast-query.fa file to cyverse
files-upload -V -v -F testfiles -S data.iplantcollaborative.org ericiam

# push blast database to cyverse
files-upload -V -v -F blastdb -S data.iplantcollaborative.org ericiam

# submit blast job
jobs-submit -V -W -F blast-job.json

# result will be in cyverse: /archive/jobs/<jobid>/output

