<#compress>
    <#assign p44 = interactionRecords[0].requestBody>
{
    "shipment_mode": "LTL",
    "ship_from_city": "${(p44.originAddress.city)}",
    "ship_from_state": "${(p44.originAddress.state)}",
    "ship_from_zip": "${(p44.originAddress.postalCode)}",
    "ship_to_city": "${(p44.destinationAddress.city)}",
    "ship_to_state": "${(p44.destinationAddress.state)}",
    "ship_to_zip": "${(p44.destinationAddress.postalCode)}",
    "line_items": [
        <#list p44.lineItems as item>
            {
                "pallets": "${(item.postalCode)}",
                "lenght": "${(item.packageDimensions.lenght)}",
                "width": "${(item.packageDimensions.width)}",
                "height": "${(item.packageDimensions.height)}",
                "weight": "${(item.totalWeight)}",
                "stackable": "${(item.stackable)}",
                "freight_class_code": "${(item.freightClass)}",
                "packageType": "${(item.packageType)}",
                "description": "${(item.description)}"
            }<#sep>,
            <#rt>
        </#list>
    ]
    "accessorial_charges": [
        <#list p44.directlyCodedAccessorialServices as item>
            {
                "type" : "${(item.code)}"
            }<#sep>,
            <#rt>
        </#list>
    ]
}



</#compress>