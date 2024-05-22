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
                <#--  dobro je, treba totalPackages ovde  -->
                "pallets": "${(item.totalPackages)!0}",     <!-- not sure about totalPackages field -->
                <#--  zavisi od kerijerovog apija, ali u principu uglavnom ne moras double ako vracas 0  -->
                <#--  takodje, nekad je string, nekad int, nekad svejedno, zavisi od apija, ali ovo je skroz tacno  -->
                "length": "${(item.packageDimensions.length)!0.0}",
                "width": "${(item.packageDimensions.width)!0.0}",
                "height": "${(item.packageDimensions.height)!0.0}",
                "weight": "${(item.totalWeight)!0}",
                <#--  ! ce ti ovde samo napraviti prazan string, isto zavisi sad od kerijera sta oni ocekuju  -->
                <#--  nekima je ok i da je prazno, neki ocekuju ili true ili false, pa ces mozda staviti (item.stackable)!"false" na primer  -->
                "stackable": "${(item.stackable)!}",    <!-- not sure about null check -->
                "freight_class_code": "${(item.freightClass)!}",
                "packageType": "${(item.packageType)!}",
                "description": "${(item.description)!}"
            }<#sep>,
            <#rt>
        </#list>
    ],
    "accessorial_charges":[
        <#assign list = p44.directlyCodedAccessorialServices + p44.indirectlyCodedAccessorialServices>
        <#if list?has_content>
        <#list list as acc>
            {
                "type":"${(acc.code)!}"
            }<#sep>,
            <#rt>
        </#list>
    ]
}


</#compress>