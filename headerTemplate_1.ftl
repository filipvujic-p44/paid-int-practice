{
    <#assign p44 = interactionRecord[0].requestBody>
    "Content-Type": "application/json",
    "Accept": "application/json",
    "x-api-key":"${(p44.vendorAuthentication.credential2)!}"
}
