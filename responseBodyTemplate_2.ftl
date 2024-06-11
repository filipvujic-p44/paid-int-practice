<#compress>

<#attempt>
	<#assign cp1 = interactionRecords[0].vendorResponseBody>
	<#assign cp1String = interactionRecords[0].vendorResponseBodyString>
	<#assign fetchedTransitTime = cp1.transit_days>
<#recover>
	<#assign cp1 = "">
	<#assign fetchedTransitTime = "">
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

<#if !cp2?has_content || !hasContent(cp2String)>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail":{},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_INVALID_RESPONSE",
			"message": ""
		}
		]
	}

<#elseif hasContent(cp2.error_msg!)>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail":{},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_DISPATCH_GENERAL",
			"message": "${(cp2.error_msg)!}"
			}
		]
	}

<#else>
{  
    "shipmentIdentifiers": [
        {
            "type": "CUSTOMER_REFERENCE",
            "value": "${(cp1.shipment_id)!}"
        }
    ],
    "shipmentConfirmationDetail":{
        "originLocation":{
            "address":{
                "addressLines": [],
                "city": null,
                "state": null,
                "postalCode": "${(cp0.origin_zip)!}",
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
                    "postalCode": "${(cp0.destination_zip)!}",
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
            "transitDays": "${(cp0.transit_days)!}"
            
        }
    },
    "infoMessages": [],
    "warningMessages": [],
    "errorMessages": []
}
</#if>

</#compress>