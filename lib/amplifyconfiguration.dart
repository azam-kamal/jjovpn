const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "e0e3b77159ee42668c4e7223ea6563ec",
                    "region": "us-east-1"
                },
                "pinpointTargeting": {
                    "region": "us-east-1"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:f9b40c79-d25e-4fb8-b64b-1d7eca1cec31",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_n6tr9xHMF",
                        "AppClientId": "6dkcpggc5kllesvcm58gj2fdio",
                        "AppClientSecret": "5lkaalrbe3fjrv0j6ribgk0b1aepj7r2bvmub5l8ekmsg6hpbjq",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "e0e3b77159ee42668c4e7223ea6563ec",
                        "Region": "us-east-1"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "us-east-1"
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "jjovpn5cc6ac394d9b419a9dcc6c64562b966c214137-dev",
                        "Region": "us-east-1"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "jjovpn5cc6ac394d9b419a9dcc6c64562b966c214137-dev",
                "region": "us-east-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';