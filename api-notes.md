# AGAVE API Notes

##Setup SDK
CLI is needed to setup initial tenents-init and helpful in Oauth config

//Install cli commands
```
curl -L https://cyverse.github.io/cyverse-sdk/install/install.sh | sh
```
Installs CLI in /home/<user>/cyverse-cli

// verify
```
cyverse-sdk-info
```

// update cli
```
cyverse-sdk-info --update
```

// setup tenant
```
tenants-init -t iplantc.org
```

## Oauth

// create an API key
```
clients-create -V -S -v -N gg_client -D "Client used for GrainGenes development"
API username : ericiam
API password: 
curl -sku "ericiam:XXXXX" -X POST -d clientName=gg_client -d "tier=Unlimited" -d "description=Client used for GrainGenes development" -d "callbackUrl=" 'https://agave.iplantc.org/clients/v2/?pretty=true'
{
  "status": "success",
  "message": "Client created successfully.",
  "version": "2.0.0-SNAPSHOT-rc3fad",
  "result": {
    "description": "Client used for GrainGenes development",
    "name": "gg_client",
    "consumerKey": "v9kRrZXC5517U1e8olScrh_ivBka",
    "_links": {
      "subscriber": {
        "href": "https://agave.iplantc.org/profiles/v2/ericiam"
      },
      "self": {
        "href": "https://agave.iplantc.org/clients/v2/gg_client"
      },
      "subscriptions": {
        "href": "https://agave.iplantc.org/clients/v2/gg_client/subscriptions/"
      }
    },
    "tier": "Unlimited",
    "consumerSecret": "1AfF4QP4WXGSMBjNoyPtI79p4FMa",
    "callbackUrl": ""
  }
}
```

// create auth token
```
auth-tokens-create -V -S -v
API password: 
curl -sku "v9kRrZXC5517U1e8olScrh_ivBka:1AfF4QP4WXGSMBjNoyPtI79p4FMa" -X POST --data-urlencode "username=ericiam" --data-urlencode "password=<password>" --data-urlencode "grant_type=password" --data-urlencode "scope=PRODUCTION" 'https://agave.iplantc.org/token'
Token for iplantc.org:ericiam successfully refreshed and cached for 14400 seconds
{
  "scope": "default",
  "token_type": "bearer",
  "expires_in": 14400,
  "refresh_token": "6bbbea49a311edada6410916e4fc896",
  "access_token": "20a9f9441538cfa3c5f97f565042b5"
}
```

// refresh auth token
```
auth-tokens-refresh -S -v
```


## Enumerate files in the CyVerse datastore
The datastore on cyverse is essentially a directory structure of files on CyVerse.

// directory listing of home
```
files-list -V -v -S data.iplantcollaborative.org ericiam
curl -sk -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" 'https://agave.iplantc.org/files/v2/listings/system/data.iplantcollaborative.org/ericiam?pretty=true'
```

// directory listing of home/blastdb  (takes a little time?)
```
files-list -V -v -S data.iplantcollaborative.org ericiam/blastdb
curl -sk -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" 'https://agave.iplantc.org/files/v2/listings/system/data.iplantcollaborative.org/ericiam/blastdb?pretty=true'
```

// directory listing of home/blastdb/faux
```
files-list -V -v -S data.iplantcollaborative.org ericiam/blastdb/faux
curl -sk -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" 'https://agave.iplantc.org/files/v2/listings/system/data.iplantcollaborative.org/ericiam/blastdb/faux?pretty=true'
```

// directory of shared directory
```
curl -sk -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" 'https://agave.plantc.org/files/v2/listings/shared?pretty=true'
```

## Copy files into to/from datastore

// copy a file to datastore
```
files-upload -V -v -F test/README.md -S data.iplantcollaborative.org ericiam
curl -# -k -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" -X POST -F "fileToUpload=@test/README.md" 'https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/ericiam?pretty=true'
```

// copy a directory "test"
// this results in a compound operation
```
files-upload -V -v -F test -S data.iplantcollaborative.org ericiam
Creating directory ericiam/test ...
Calling /home/ericiam/cyverse-cli/bin/files-mkdir  -V -v -S data.iplantcollaborative.org -N test ericiam
Creating directory ericiam/test/bin ...
Calling /home/ericiam/cyverse-cli/bin/files-mkdir  -V -v -S data.iplantcollaborative.org -N bin ericiam/test
curl -# -k -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" -X POST -F "fileToUpload=@test/README.md" 'https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/ericiam/test?pretty=true'
```

// makedir "hihi"
```
files-mkdir  -V -v -S data.iplantcollaborative.org -N hihi ericiam
Calling curl -sk -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" -X PUT -d "action=mkdir&path=hihi" 'https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/ericiam?pretty=true'
```

// make dir "hellothere" and a subdir "bin"
```
files-mkdir  -V -v -S data.iplantcollaborative.org -N bin ericiam/hellothere
curl -sk -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" -X PUT -d "action=mkdir&path=bin" 'https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/ericiam/hellothere?pretty=true'
```

// download a file from datastore "dingo/README.md"
```
files-get -V -v -N sloth.fastq.gz -S data.iplantcollaborative.org ericiam/sloth/SRR857575_1.fastq.gz
Calling curl -k -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b"  -o sloth.fastq.gz 'https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/ericiam/sloth/SRR857575_1.fastq.gz'
```

// cannot download directory from datastore

## Search for App
```
apps-search -V -v id.like="*blastn*"
curl -G -sk -H "Authorization: Bearer d56b1f7b31e099a53f7a1b281ad87a1b" 'https://agave.iplantc.org/apps/v2?pretty=true'   --data id.like=%2Ablastn%2A)
```

// gets app template with required parameters
```
jobs-template uncompress_gunzip-0.0.0u1
```

// gets app template with all parameters and inputs
```
jobs-template -A uncompress_gunzip-0.0.0u1
```

## Submit gzip Job

// basic gzip test (working)
```
gunzip-job.json:
{
    "jobName": "gunzip-demo",
    "appId": "uncompress_gunzip-0.0.0u1",
    "archive": true,
    "inputs": {
          "files":  "agave://data.iplantcollaborative.org/ericiam/sloth/IMG_0587.JPG.gz"
    },
    "parameters":{
    }
}
jobs-submit -V -W -F gunzip-job.json
```

## Submit blast job
BLAST APP

//Find blast app
```
apps-search -V -v id.like="*blastn*"
curl -G -sk -H "Authorization: Bearer d1dd35ecdf5d186261ac071bcd979" 'https://agave.iplantc.org/apps/v2?pretty=true'   --data id.like=%2Ablastn%2A)
{
  "status" : "success",
  "message" : null,
  "version" : "2.2.20-r7f2871d",
  "result" : [ {
    "id" : "blastn_2.2.31-0.0.0u1",
    "name" : "blastn_2.2.31",
    "version" : "0.0.0",
    "revision" : 1,
    "executionSystem" : "cyverseUK-Batch2",
    "shortDescription" : "nucleotide BLAST",
    "isPublic" : true,
    "label" : "Blastn",
    "lastModified" : "2017-05-25T09:56:03.000-05:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/apps/v2/blastn_2.2.31-0.0.0u1"
      }
    }
  } ]
}
```

// get blast app template
```
jobs-template -A blastn_2.2.31-0.0.0u1
{
  "name":"blastn_2.2.31 test-1529543097",
  "appId": "blastn_2.2.31-0.0.0u1",
  "batchQueue": "normal",
  "executionSystem": "cyverseUK-Batch2",
  "maxRunTime": "01:00:00",
  "memoryPerNode": "1GB",
  "nodeCount": 1,
  "processorsPerNode": 1,
  "archive": true,
  "archiveSystem": "data.iplantcollaborative.org",
  "archivePath": null,
  "inputs": {
    "query": "",
    "blast_db": "",
    "subject": "",
    "import_search_strategy": ""
  },
  "parameters": {
    "dust": "31DfGd5",
    "soft_masking": true,
    "parse_deflines": false,
    "use_index": false,
    "xdrop_ungap": "Oqpucf6",
    "query_loc": "u6c/9j4",
    "window_size": "33vfV3X",
    "outfmt": "0",
    "word_size": "ACuRfcY",
    "db_soft_mask": "ZLEZJ1t",
    "penalty": "ZHoHrpr",
    "evalue": "CkUc5lB",
    "num_alignments": "250",
    "max_target_seqs": "500",
    "max_hsps": "zSTJ8so",
    "line_length": 60,
    "filtering_db": "asmeDYv",
    "lcase_masking": false,
    "xdrop_gap": "9uAQ5rL",
    "index_name": "xbfCeu2",
    "min_raw_gapped_score": "ce8svPn",
    "seqidlist": "Z+X0pBy",
    "db_hard_mask": "6IAQWBF",
    "strand": "both",
    "off_diagonal_range": 0,
    "show_gis": false,
    "gapopen": "AlQ0VQJ",
    "best_hit_overhang": "gXtz3Cj",
    "perc_identity": "EiXtVjG",
    "culling_limit": "zdL5fEs",
    "template_type": ,
    "html": false,
    "window_masker_taxid": "ID3TwhR",
    "gilist": "A7GHarb",
    "template_length": ,
    "reward": "cO53TJh",
    "subject_loc": "nsg19gy",
    "xdrop_gap_final": "xPJ7uFq",
    "negative_gilist": "35Elil3",
    "ungapped": false,
    "task": "megablast",
    "num_descriptions": "500",
    "gapextend": "vDWucm8",
    "qcov_hsp_perc": "iE9e5T8",
    "best_hit_score_edge": "WhTquRB"
  },
  "notifications": [
    {
      "url":"https://requestbin.agaveapi.co/10ctf3s1?job_id=${JOB_ID}&status=${JOB_STATUS}",
      "event":"*",
      "persistent":true
    },
    {
      "url":"ericiam@berkeley.edu",
      "event":"FINISHED",
          "persistent":false
    },
    {
      "url":"ericiam@berkeley.edu",
      "event":"FAILED",
      "persistent":false
    }
  ]
}
```

// submit blast job
```
blast-job.json
{
    "jobName": "blast-demo",
    "appId": "blastn_2.2.31-0.0.0u1",
    "archive": true,
    "inputs": {
          "blast_db":  "agave://data.iplantcollaborative.org/ericiam/blastdb/faux",
          "query":  "agave://data.iplantcollaborative.org/ericiam/testfiles/blast-query.fa"
    },
    "parameters":{
        "outfmt": "5"
    }
}
jobs-submit -V -W -F blast-job.json
```
The result file is /archive/jobs/<jobid>/output (xml)
