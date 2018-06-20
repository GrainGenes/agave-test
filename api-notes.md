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

## Submit Job

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


