<#compress>
    <#assign p44 = interactionRecords[0].requestBody>
{
    "shipment_mode": "LTL",
    "ship_from_city": "${(p44.originAddress.city)!}",
    "ship_from_state": "${(p44.originAddress.state)!}",
    "ship_from_zip": "${(p44.originAddress.postalCode)!}",
    "ship_to_city": "${(p44.destinationAddress.city)!}",
    "ship_to_state": "${(p44.destinationAddress.state)!}",
    "ship_to_zip": "${(p44.destinationAddress.postalCode)!}",
    "line_items": [
        <#list p44.lineItems as item>
            {
                "pallets": "${(item.totalPackages)!}",
                "lenght": "${(item.packageDimensions.lenght)!0}",
                "width": "${(item.packageDimensions.width)!0}",
                "height": "${(item.packageDimensions.height)!0}",
                "weight": "${(item.totalWeight)!0}",
                "stackable": "${(item.stackable?string("true", "false"))!}",
                "freight_class_code": "${(item.freightClass)!}",
                "packageType": "${(item.packageType)!}",
                "description": "${(item.description)!}"
            }<#sep>,
            <#rt>
        </#list>
    ]
    	<#--  spoj obe liste  -->
    <#assign lista = p44.directlyCodedAccessorialServices + p44.indirectlyCodedAccessorialServices>
    "accessorial_charges": [
        <#list lista as item>
            {
                "type" : "${(item.code)!}"
            }<#sep>,
            <#rt>
        </#list>
    ]
}



</#compress>