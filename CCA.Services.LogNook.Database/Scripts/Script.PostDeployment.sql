:r .\Permissions.sql

SET IDENTITY_INSERT [dbo].[PeanutButter] ON 

MERGE INTO [dbo].[PeanutButter] pb
USING (VALUES 
	(1, N'JIF',0,
N' "_id": "00e571b0-a6e8-4709-aaad-3b50f82bdcbb",
  "emailAddresses": ["mmazurik@epiqglobal.com"],
  "subject": "LogNook Service POST called. Document is ready to sign",
  "name" : "Marty Mazurik",
  "fields": [
    { "name": "caseName",
      "fieldType": "Text",
      "dataType" : "string",
      "value" : "Hollywood vs. Oil Claim Jumper"
    },
    { "name": "claimantName",
      "fieldType": "Text",
      "dataType" : "string",
      "value" : "Jed Clampett"
    }
    ]
}'),
(2, N'Skippy Brand',1,
N' "_id": "00e571b0-a6e8-4709-aaad-3b50f82bdcbb","someJSONinfo": "in case you have not noticed, the structure of the JSON data, has no constraints or rules at the DAL or Databaqse level." )')
) v  ([PeanutButterId], [Brand], [IsChunky],[JsonData]) on pb.PeanutButterId = v.PeanutButterId and pb.Brand = v.Brand
WHEN NOT MATCHED THEN INSERT ([PeanutButterId], [Brand], [IsChunky],[JsonData])
VALUES (v.[PeanutButterId], v.[Brand], v.[IsChunky], v.[JsonData]);

SET IDENTITY_INSERT [dbo].PeanutButter OFF
