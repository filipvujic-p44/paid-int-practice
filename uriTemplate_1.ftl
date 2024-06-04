<#compress>
    <#assign p44 = interactionRecords[0].requestBody>
    https://rtta/api/v1/shipment/transitdays?originzip=${(p44.originLocation.postalCode)!}&destinationzip=${(p44.destinationLocation.postalCode)!}&pickupdate=${(p44.pickupWindow.date)!}
</#compress>