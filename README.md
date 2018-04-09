# Artifact creation recipes

Scripts for creating a party group, party, tenure, and spatial unit
in Open Index Protocol using Flo's RPC and Desoto's llama services.

## Currently compatible with oip-041

The scripts uses entity publish templates that are compatible with OIP's version `oip-041` instead of `oip042`. The Alexandria
team plans to upgrade `oipdaemon` to be compatible with `oip-042` in the near future (April 2018). When the upgrade
occurs, these examples will have to change the message templates to be compatible with `oip042`. Monitor the [Alexandria
chat](https://chat.alexandria.io) to know when this occurs.

## Quick instructions using the Bash scripts

### Install IPFS

1. Go to [IPFS website](https://ipfs.io/docs/install/) and install as directed for your platform.
1. Make sure `ipfs` is on your PATH environment variable.
1. Launch the IPFS daemon in its own terminal window.
    ```bash
    $ ipfs daemon
    ```


### Create (or register) a new OIP Publisher

1. Acquire a new FLO address that has some funds. 1 FLO is plenty.

    ```bash
    $ FLO_CONF="`pwd`/flo.conf"
    $ PUBLISHER_ADDRESS=`flo-cli -conf=$FLO_CONF getnewaddress ""` 
    ```

1. Register a publisher in Open Index Protocol

    ```bash
    $ ./create_publisher.sh $PUBLISHER_ADDRESS
    ```

### Create 2 Party Artifacts

1. Use that address as the first argument of `create_party.sh`
    ```bash
    $ ./create_party.sh $PUBLISHER_ADDRESS
    Signing with this message: {"address":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","text":"QmW5msdWJstADw34Fs1UoiLheneLQ7mqdSXs23rBWeUqFr-oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS-1523053433"}
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   274  100   124  100   150   1469   1777 --:--:-- --:--:-- --:--:--  1785
    {"oip-041":{"artifact":{"timestamp":1523053433,"type":"property","subtype":"party","publisher":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","info":{"title":"Property Party /ds-property/tmp-21450","description":"Usefuldescription","year":2018,"tags":"party,test,demo","ns":"DS","partyRole":"citizen","partyType":"naturalPerson","attrs":[],"extraInfo":{}},"storage":{"network":"IPFS","location":"QmW5msdWJstADw34Fs1UoiLheneLQ7mqdSXs23rBWeUqFr","files":[{"fName":"document.txt","fSize":111,"dName":"Placeholder","fType":"Placeholder","cType":"text/plain"}]}},"signature":"IOgqzDjgEmPxYfzr6baKUUYbIHGl0ySnQNZxC1vYimQ+S+nQZ2+EwDkKDlbLr64KvcB3Pq+mQZHwhHIMB2lV78o="}}
    {"status":"success","response":["ab66f0b60b08ec7bd8c93c8a5162748b08df3198522887a1593b2e62ee13b57e","a87bcb1f7e5babbf82099f25bf935f6196d08da19295a77ff6b3ba7c80c2e191","4a51ae4d5a0fc84f71fdadd3972d2c87a0fd59eef0497c9e37171966baac0743"]}
    ```
    
    Copy the first txid in the response array. In this example it would be `ab66f0b60b08ec7bd8c93c8a5162748b08df3198522887a1593b2e62ee13b57e`.
    
    ```
    MEMBER1=ab66f0b60b08ec7bd8c93c8a5162748b08df3198522887a1593b2e62ee13b57e
    ``` 
    
1. Create another Party artifact and copy its txid.

    ```bash
    $ ./create_party.sh $PUBLISHER_ADDRESS
    Signing with this message: {"address":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","text":"Qmc1GPsecsoywCvW6RuCBq7mCDxEJJ2i7Lps2V9FcMPkpa-oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS-1523053691"}
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   274  100   124  100   150   1560   1887 --:--:-- --:--:-- --:--:--  1898
    {"oip-041":{"artifact":{"timestamp":1523053691,"type":"property","subtype":"party","publisher":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","info":{"title":"Property Party /ds-property/tmp-6197","description":"Usefuldescription","year":2018,"tags":"party,test,demo","ns":"DS","partyRole":"citizen","partyType":"naturalPerson","attrs":[],"extraInfo":{}},"storage":{"network":"IPFS","location":"Qmc1GPsecsoywCvW6RuCBq7mCDxEJJ2i7Lps2V9FcMPkpa","files":[{"fName":"document.txt","fSize":110,"dName":"Placeholder","fType":"Placeholder","cType":"text/plain"}]}},"signature":"H60RLujPHD+Q15XB9j2JfzAL/sisPJpE3T4J9imH8CCHFhPpa1zirOdA3I7ExdjM1hHR73eA1CN4wgU6GIm032E="}}
    {"status":"success","response":["202fdc02e70720635ee0eb4e56b70c9be5008e172688aa62ea9a9dbe7c51eb38","2a663c41baf52803997766284eb72e06331c5d0a54f7d0821237e70594ecebd4","843dc6a48b1ca4a78af028725ffacbdbf1c42ccd41855ad375c17969d71ae6fa"]}
    
    $ MEMBER2=202fdc02e70720635ee0eb4e56b70c9be5008e172688aa62ea9a9dbe7c51eb38
    ```
    
1. Create a Party Group artifact using the addresses of MEMBER1 and MEMBER2. Use PUBLISHER_ADDRESS as the first argument.
   The remaining command line arguments are the FLO addresses of every party member.

    ```bash
    $ ./create_party_group.sh $PUBLISHER_ADDRESS $MEMBER1 $MEMBER2
    Signing with this message: {"address":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","text":"QmV268u9awAVzzgbsKDs5aRMyhUPFvk3KZZrCmd8H4qtMb-oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS-1523055454"}
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   274  100   124  100   150   1422   1721 --:--:-- --:--:-- --:--:--  1724
    {"oip-041":{"artifact":{"timestamp":1523055454,"type":"property","subtype":"party","publisher":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","info":{"title":"Property Party /ds-property/tmp-12868","description":"Usefuldescription","year":2018,"tags":"party,test,demo","ns":"DS","partyRole":"association","partyType":"group","members":["ab66f0b60b08ec7bd8c93c8a5162748b08df3198522887a1593b2e62ee13b57e","202fdc02e70720635ee0eb4e56b70c9be5008e172688aa62ea9a9dbe7c51eb38"],"attrs":[],"extraInfo":{}},"storage":{"network":"IPFS","location":"QmV268u9awAVzzgbsKDs5aRMyhUPFvk3KZZrCmd8H4qtMb","files":[{"fName":"document.txt","fSize":111,"dName":"Placeholder","fType":"Placeholder","cType":"text/plain"}]}},"signature":"ILKvOBQx8+BF04hEEUJrtmjv0+ipO+hqnfOAWNm6pLPFC03wKW80/92+bGv6oJx+w9g7SzkQ9XR7upAi7pb/BAg="}}
    {"status":"success","response":["10279cd749a87174eb582b24d13c4d4eaec0e656bb009e29e89473da4b7a7a73","eadd5501453eb6099728ecb612450d8be637917f565cf3daf1ce2336a01c0d11","c175dda2de786a394e15231ccbf8c4618728aad716f0522ca586136ab408fd79"]}
    ```

1. Save the Party Group's txid into a variable to use when creating the tenure.

    ```bash
    PARTY_GROUP=10279cd749a87174eb582b24d13c4d4eaec0e656bb009e29e89473da4b7a7a73
    ````
### Create a Spatial Unit Artifact

1. Create a Spatial Unit artifact by using `create_spat.sh`. The first command line parameter is the PUBLISHER_ADDRESS.

    ```bash
    $  ./create_spat.sh $PUBLISHER_ADDRESS 
      Signing with this message: {"address":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","text":"QmdFsjV2wHG5CZyfCgqHz1ASCYQsSmzCWHz1JnLMTXdy4o-oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS-1523055813"}
        % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                       Dload  Upload   Total   Spent    Left  Speed
      100   274  100   124  100   150   1433   1733 --:--:-- --:--:-- --:--:--  1744
      {"oip-041":{"artifact":{"timestamp":1523055813,"type":"property","subtype":"spatialUnit","publisher":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","info":{"title":"Property Spatial Unit /ds-property/tmp-su-30751","description":"Property Spatial Unit /ds-property/tmp-su-30751 description","year":2018,"tags":"spatialUnit,test,demo","ns":"DS","geometry":{"type":"text","data":"Bounded by the alpha and beta rivers, iron hills to flame gulch"},"spatialType":"text","attrs":[],"extraInfo":{}},"storage":{"network":"IPFS","location":"QmdFsjV2wHG5CZyfCgqHz1ASCYQsSmzCWHz1JnLMTXdy4o","files":[{"fName":"document_27090.txt","fSize":131,"dName":"Placeholder","fType":"Placeholder","cType":"text/plain"}]}},"signature":"IPoFUkvUER5UpytUou8IwymCXgctNM/00PhMC9SW8ZnKGLG31hJeMl/RuMc0Q1vKstYZlsTCzURuioJ7Ta+dtSo="}}
      {"status":"success","response":["8d1649ffd1e6d96c2a039e035b726db6a70b436fa9b5a93ee87867b86a1c7325","ce6ea9c8e8439ca813e5eb2d33c65886a3dc4e8911818f230c35b0ff244f90a0","f4aa1037df202394171e751a9ef6c73d0f991de2f22cd52f16525dde45f9dcfa"]}
    ```
    
1. Save the Spatial Unit's txid into a variable.

    ```bash
    $ SPATIAL_UNIT=8d1649ffd1e6d96c2a039e035b726db6a70b436fa9b5a93ee87867b86a1c7325
    ```

### Create a Tenure that Relates Party Group with Spatial Unit

1. Use the `create_tenure.sh` script. The first command line parameter is the PUBLISHER_ADDRESS.

    ```bash
    $ ./create_tenure.sh $PUBLISHER_ADDRESS $PARTY_GROUP $SPATIAL_UNIT 
    Signing with this message: {"address":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","text":"QmWQgYFPhN6MnkKamywvrVMW1JztrUKNQvvojMzMWTr1GW-oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS-1523057759"}
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   274  100   124  100   150   1480   1791 --:--:-- --:--:-- --:--:--  1807
    {"oip-041":{"artifact":{"timestamp":1523057759,"type":"property","subtype":"tenure","publisher":"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS","info":{"title":"Property Tenure /ds-property/tmp-tenure-19501","description":"Property Tenure /ds-property/tmp-tenure-19501 description","year":2018,"tags":"tenure,test,demo","ns":"DS","tenureType":"freehold","party":"10279cd749a87174eb582b24d13c4d4eaec0e656bb009e29e89473da4b7a7a73","spatialUnit":"8d1649ffd1e6d96c2a039e035b726db6a70b436fa9b5a93ee87867b86a1c7325","attrs":[],"extraInfo":{}},"storage":{"network":"IPFS","location":"QmWQgYFPhN6MnkKamywvrVMW1JztrUKNQvvojMzMWTr1GW","files":[{"fName":"document_20373.txt","fSize":129,"dName":"Tenure Entity /ds-property/tmp-tenure-19501","fType":"Placeholder","cType":"text/plain"}]}},"signature":"IF1LKC7RS9w+Ie/v8KRjaSLihdtj4rgJynO3V0s2qZFBNk8TXzZtJzDTlZKQ/4PtNef/tuLkTdvi7kn5aKscsms="}}
    {"status":"success","response":["4ccf3f0ed6973a31ba9967fbb8e5f7f61e5ddd5a60f50fb2f807e220975b58ff","fc9b2b916926531684bd21ab0c4b06534584b466dca93998bdecbcf3615e4b90","59dbe6c2f996ffefc6d417086b15f946f21c7590933353ff570af547c127c753","9c397e723895850c9cb908882665718ba6bee9698df3fe70f7e53514a538a402"]}
    ```

1. Verify the spatial unit txid with either the testnet explorer or flo-cli.

    ```bash
    $ flo-cli -conf=$FLO_CONF getrawtransaction "4ccf3f0ed6973a31ba9967fbb8e5f7f61e5ddd5a60f50fb2f807e220975b58ff" 1
      {
        "txid": "4ccf3f0ed6973a31ba9967fbb8e5f7f61e5ddd5a60f50fb2f807e220975b58ff",
        "hash": "4ccf3f0ed6973a31ba9967fbb8e5f7f61e5ddd5a60f50fb2f807e220975b58ff",
        "version": 2,
        "size": 868,
        "vsize": 868,
        "locktime": 91517,
        "vin": [
          {
            "txid": "4e56dac12490151ef64f00e9cd37857220ab45da7ce451cc79a4be1ac901b958",
            "vout": 0,
            "scriptSig": {
              "asm": "3045022100fc309b89fa7c858bbac60633478352dde15a72a8f783255cf3c71f86ca321c5702207e725f2b9cbe5f67e0cc78f7cbe4b329cace0e484f867248d47e97b4850baff7[ALL] 0207018400ff8f56582689ab817fcf555d32c0d0d4a79c76b3a5f83d3fb600df7a",
              "hex": "483045022100fc309b89fa7c858bbac60633478352dde15a72a8f783255cf3c71f86ca321c5702207e725f2b9cbe5f67e0cc78f7cbe4b329cace0e484f867248d47e97b4850baff701210207018400ff8f56582689ab817fcf555d32c0d0d4a79c76b3a5f83d3fb600df7a"
            },
            "sequence": 4294967294
          }, 
          {
            "txid": "536d4a2588678803808ca04a58efdb0b691d3ed91b5e426a27dcc263e2378763",
            "vout": 0,
            "scriptSig": {
              "asm": "3045022100a08cc96f488aee0bd214ce7c56492c34bea4ecd780fed58117e13796f88da8dc0220554a64f0555110f1dc62cf61667c179c1c54eb9f1e0306d02f6b2651dea73044[ALL] 02b1ec85a7895e2dc979b6ba2ad7bc9a5768660b4f0ec6d923f5fb9c6faea77566",
              "hex": "483045022100a08cc96f488aee0bd214ce7c56492c34bea4ecd780fed58117e13796f88da8dc0220554a64f0555110f1dc62cf61667c179c1c54eb9f1e0306d02f6b2651dea73044012102b1ec85a7895e2dc979b6ba2ad7bc9a5768660b4f0ec6d923f5fb9c6faea77566"
            },
            "sequence": 4294967294
          }
        ],
        "vout": [
          {
            "value": 1.00000000,
            "n": 0,
            "scriptPubKey": {
              "asm": "OP_DUP OP_HASH160 5e8c858abf782b31b5a555280317ed05ba000511 OP_EQUALVERIFY OP_CHECKSIG",
              "hex": "76a9145e8c858abf782b31b5a555280317ed05ba00051188ac",
              "reqSigs": 1,
              "type": "pubkeyhash",
              "addresses": [
                "oRVJ68pqd3WsPzHr7cN8RrQyHqJaDAuwQC"
              ]
            }
          }, 
          {
            "value": 0.95799159,
            "n": 1,
            "scriptPubKey": {
              "asm": "OP_DUP OP_HASH160 3974bc3f00d79b0b94fbabdfed51bc889e219936 OP_EQUALVERIFY OP_CHECKSIG",
              "hex": "76a9143974bc3f00d79b0b94fbabdfed51bc889e21993688ac",
              "reqSigs": 1,
              "type": "pubkeyhash",
              "addresses": [
                "oN7AbLSndqLnddaE9uHVQVHth9bx7kAMc5"
              ]
            }
          }
        ],
        "floData": "alexandria-media-multipart(0,3,oRVJ68pqd3WsPzHr7cN8RrQyHqJaDAuwQC,0000000000000000000000000000000000000000000000000000000000000000,H+WvDLcniHyMhN5KriDD3T8KcLCHhQXBH+RkjkHprloTAB5M/M/yh5v0v6JZWy2zqjD1MAfq0h9wep814NL63Xs=):{\"oip-041\":{\"artifact\":{\"timestamp\":1523057759,\"type\":\"property\",\"subtype\":\"tenure\",\"publisher\":\"oNrRcWEdNZeiqB7SLgrAemLftpLw7rjAGS\",\"info\":{\"title\":\"Property Tenure /ds-property/tmp-tenure-19501\",\"description\":\"Property Tenure /ds-property/tmp-tenure-19501 description\"",
        "hex": "020000000258b901c91abea479cc51e47cda45ab20728537cde9004ff61e159024c1da564e000000006b483045022100fc309b89fa7c858bbac60633478352dde15a72a8f783255cf3c71f86ca321c5702207e725f2b9cbe5f67e0cc78f7cbe4b329cace0e484f867248d47e97b4850baff701210207018400ff8f56582689ab817fcf555d32c0d0d4a79c76b3a5f83d3fb600df7afeffffff638737e263c2dc276a425e1bd93e1d690bdbef584aa08c8003886788254a6d53000000006b483045022100a08cc96f488aee0bd214ce7c56492c34bea4ecd780fed58117e13796f88da8dc0220554a64f0555110f1dc62cf61667c179c1c54eb9f1e0306d02f6b2651dea73044012102b1ec85a7895e2dc979b6ba2ad7bc9a5768660b4f0ec6d923f5fb9c6faea77566feffffff0200e1f505000000001976a9145e8c858abf782b31b5a555280317ed05ba00051188ac77c7b505000000001976a9143974bc3f00d79b0b94fbabdfed51bc889e21993688ac7d650100fdeb01616c6578616e647269612d6d656469612d6d756c74697061727428302c332c6f52564a3638707164335773507a487237634e385272517948714a614441757751432c303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030302c482b5776444c636e6948794d684e354b726944443354384b634c434868515842482b526b6a6b4870726c6f544142354d2f4d2f796835763076364a5a5779327a716a44314d4166713068397765703831344e4c363358733d293a7b226f69702d303431223a7b226172746966616374223a7b2274696d657374616d70223a313532333035373735392c2274797065223a2270726f7065727479222c2273756274797065223a2274656e757265222c227075626c6973686572223a226f4e7252635745644e5a6569714237534c677241656d4c6674704c7737726a414753222c22696e666f223a7b227469746c65223a2250726f70657274792054656e757265202f64732d70726f70657274792f746d702d74656e7572652d3139353031222c226465736372697074696f6e223a2250726f70657274792054656e757265202f64732d70726f70657274792f746d702d74656e7572652d3139353031206465736372697074696f6e22",
        "blockhash": "29ea675182e07c752a99db7369bbce6d9465500becba889923a14c07b7d5c5f6",
        "confirmations": 1,
        "time": 1523057796,
        "blocktime": 1523057796
      }

    ```
    
 ### Placeholder documents in IPFS
 
 You may verify that the placeholder documents are stored in IPFS. The property in `artifact.storage.location` holds the
 IPFS hash of the documents' DAG. You can use a browser to see it.
    
    ```bash
    https://ipfs.io/ipfs/QmWQgYFPhN6MnkKamywvrVMW1JztrUKNQvvojMzMWTr1GW
    ```
 