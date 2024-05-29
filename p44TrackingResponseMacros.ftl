<#macro ingestionEvent estimateTimestamp="0" timestamp="0" scac="N/A" statusCode="" description=""
city="" state="" country="US" postalCode="" shipmentIdentifiers=[] lat=0, lon=0>
    {
    "sourceType": {
    "string": "PULL:CARRIER"
    },
    "reality": {
    "string": ""
    },
    "timestampOffset": {
    "string": ""
    },
    "estimateTimestamp": {
    "long": ${estimateTimestamp}
    },
    "sourceTenantId": {
    "int": 0
    },
    "ownerTenantId": {
    "int": 0
    },
    "userId": {
    "int": 0
    },
    "eventType": "${templateUtil.getCodeTranslation(statusCode, valueTranslations.vendorShipmentStatusEventTypePrefixMap)!"EVENT-TYPE-EMPTY"}",
    "timestamp": ${timestamp},
    "identifiers": {
    "array": [
    <#list shipmentIdentifiers?filter(x->x?is_hash) as identifier>
        ${identifier?is_first?string("", ",")}
        <@shipmentIdentifier identifier/>
    </#list>
    ]
    },
    "carrierIdentifiers": {
    "array": [
    {
    "type": "SCAC",
    "value": "${scac}"
    }
    ]
    },
    "status": {
    "com.p44.common.Status": {
    "codes": {
    "array": [
    {
    "type": "STATUS_CODE",
    "value": "${templateUtil.getCodeTranslation(statusCode, valueTranslations.vendorShipmentStatusUpdateCodePrefixMap)!"STATUS-CODE-EMPTY"}"
    }
    ]
    },
    "description": {
    "string": "${description}"
    },
    "timeRange": {
    "com.p44.common.TimeRange": {
    "startDateTime": 0,
    "endDateTime": 0
    }
    }
    }
    },
    "stop": {
    "com.p44.common.EventStop": {
    "stopId": "",
    "stopType": {
    "string": "${templateUtil.getCodeTranslation(statusCode, valueTranslations.vendorShipmentStatusStopTypePrefixMap)!}"
    },
    "stopName": {
    "string": ""
    }
    }
    },
    "locationDetails": {
    "com.p44.common.Location": {
    "locationId": {
    "string": ""
    },
    "name": {
    "string": ""
    },
    "type": {
    "string": ""
    },
    "contact": {
    "com.p44.common.Contact": {
    "companyName": {
    "string": ""
    },
    "contactName": {
    "string": ""
    },
    "phoneNumber": {
    "string": ""
    },
    "phoneNumberCountryCode": {
    "string": ""
    },
    "phoneNumber2": {
    "string": ""
    },
    "phoneNumber2CountryCode": {
    "string": ""
    },
    "email": {
    "string": ""
    },
    "faxNumber": {
    "string": ""
    },
    "faxNumberCountryCode": {
    "string": ""
    }
    }
    },
    "address": {
    "com.p44.common.Address": {
    "addressLines": {
    "array": []
    },
    "city": {
    "string": "${city}"
    },
    "state": {
    "string": "${state}"
    },
    "country": {
    "string": "${country}"
    },
    "postalCode": {
    "string": "${postalCode}"
    }
    }
    },
    "identifiers": {
    "array": []
    }
    }
    },
    "additionalLocations": {
    "array": []
    },
    "position": {
    "com.p44.common.Position": {
    "lat": ${lat},
    "lon": ${lon}
    }
    },
    "mode": {
    "string": "LTL"
    }
    }
</#macro>
<#macro shipmentIdentifier identifier>
    {
    "type": "${(identifier["type"])!}",
    "value": "${(identifier["value"])!}",
    "primaryForType": {
    "boolean": false
    }
    }
</#macro>
<#macro error ourCode="" vendorCode="" message="" messages=[]>
    {
    "responseType": "CARRIER_ERROR",
    "data": {
    "p44Code": "${ourCode}",
    "cpCode": "${vendorCode}"
    <#if messages?has_content>
        <#list messages as msg>
            ,"cpMessage": "${msg}"
        </#list>
    <#else>
        ,"cpMessage": "${message}"
    </#if>
    }}
</#macro>