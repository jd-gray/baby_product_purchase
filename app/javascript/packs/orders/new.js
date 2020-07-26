(function () {
  window.renderGiftInformation = function () {
    const checkBox = document.getElementById("is-gift-checkbox");

    const shippingAddressDiv = document.getElementById("shipping-address");
    const shippingAddressFields = ["order_address", "order_zipcode"];

    const giftInformationDiv = document.getElementById("gift-information");
    const giftInformationFields = ["order_from", "order_message"];

    if (checkBox.checked == true) {
      shippingAddressDiv.style.display = "none";
      clearFields(shippingAddressFields);

      giftInformationDiv.style.display = "block";
    } else {
      shippingAddressDiv.style.display = "flex";

      // TODO: Clear hidden is_gift field
      giftInformationDiv.style.display = "none";
      clearFields(giftInformationFields);
    }
  };

  function clearFields(fieldsArr) {
    fieldsArr.forEach(function (field) {
      document.getElementById(field).value = "";
    });
  }
})();
