<#compress>
<#setting number_format="computer">

<#attempt>
	<#assign cp1 = interactionRecords[0].vendorResponseBody>
	<#assign cp1String = interactionRecords[0].vendorResponseBodyString>
<#recover>
	<#assign cp1 = "">
</#attempt>

<#attempt>
	<#assign cp2 = interactionRecords[1].vendorResponseBody>
	<#assign cp2String = interactionRecords[1].vendorResponseBodyString>
<#recover>
	<#assign cp2 = "">
</#attempt>

<#function hasContent node>
	<#return node?? && node?has_content && node?trim?has_content>
</#function>

<#if !(cp2String?has_content)>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail": {},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_INVALID_RESPONSE",
			"message": ""
		}]
	}
<#elseif cp2.status != true>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail": {},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_DISPATCH_GENERAL",
			"message": "${(cp2.error_msg)!}"
		}]
	}
<#else>
{
	"shipmentIdentifiers": [
        {
            "type": "PICKUP",
            "value": "${(cp2.shipment_id)!}"
        }
    ],
    "shipmentConfirmationDetail":{
        "originLocation":{
            "address":{
                "addressLines": [],
                "city": null,
                "state": null,
                "postalCode": "${(cp1.origin_zip)!}",
                "country": null
            },
            "contact":{
                "companyName": null,
                "contactName": null,
                "email": null,
                "phoneNumber": null,
                "phoneNumber2": null,
                "faxNumber": null
            },
            "destinationLocation":{
                "address":{
                    "addressLines": [],
                    "city": null,
                    "state": null,
                    "postalCode": "${(cp1.destination_zip)!}",
                    "country": null
                },
                "contact":{
                    "companyName": null,
                    "contactName": null,
                    "email": null,
                    "phoneNumber": null,
                    "phoneNumber2": null,
                    "faxNumber": null
                }
            },
            "transitDays": "${(cp1.transit_days)!0}"
            
        }
    },
    "infoMessages": [],
    "warningMessages": [],
    "errorMessages": []
}
</#if>
</#compress>