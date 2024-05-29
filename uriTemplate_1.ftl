<#compress>
    <#assign p44 = interactionRecords[0].requestBody>
    
    https://rtta/api/v1/tracking?id=${(p44.shipmentIdentifier.value)!0}
</#compress>