# upload files to cyverse
files-upload -V -v -F testfiles -S data.iplantcollaborative.org ericiam

# submit gzip job
jobs-submit -V -W -F gzip-job.json

# retrieve result

