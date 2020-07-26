(function () {
  window.renderGiftInformation = function () {
    const checkBox = document.getElementById("is-gift-checkbox");

    const shippingAddressDiv = document.getElementById("shipping-address");
    const shippingAddressFields = ["order_address", "order_zipcode"];

    const giftInformationDiv = document.getElementById("gift-information");
    const giftInformationFields = ["order_from", "order_message"];

    if (checkBox.checked == true) {
      shippingAddressDiv.style.display = "none";
      document.getElementById("order_is_gift").value = "true";
      clearFields(shippingAddressFields);

      document.getElementById("shipping-name").innerHTML = "Parents Name";
      document.getElementById("childs-name").innerHTML = "Child's Name";
      document.getElementById("childs-birthdate").innerHTML =
        "Child's Birthdate";

      giftInformationDiv.style.display = "block";
    } else {
      shippingAddressDiv.style.display = "flex";

      document.getElementById("shipping-name").innerHTML = "Your Name";
      document.getElementById("childs-name").innerHTML = "Your Child's Name";
      document.getElementById("childs-birthdate").innerHTML =
        "Your Child's Birthdate (or expected date)";

      giftInformationDiv.style.display = "none";
      document.getElementById("order_is_gift").value = "";
      clearFields(giftInformationFields);
    }
  };

  function clearFields(fieldsArr) {
    fieldsArr.forEach(function (field) {
      document.getElementById(field).value = "";
    });
  }
})();
