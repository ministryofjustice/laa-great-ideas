document.addEventListener("DOMContentLoaded", function(){

  var business_area = document.getElementById('business-area');
  var area_of_interest = document.getElementById('idea_area_of_interest');
  var it_system = document.getElementById('it-system');

  business_area.style.display = 'none';
  it_system.style.display = 'none';

  area_of_interest.addEventListener('change', function() {
   if (area_of_interest.value === 'other_business_area'){
    business_area.style.display = "block"
   }else {
      business_area.style.display = "none"
   }
   if (area_of_interest.value === 'it_development'){
     it_system.style.display = "block"
   }else {
      it_system.style.display = "none"
   }
  });

});



