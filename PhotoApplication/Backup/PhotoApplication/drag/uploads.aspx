<%@ Page Title="" Language="C#" MasterPageFile="~/Photo.Master" AutoEventWireup="true" CodeBehind="uploads.aspx.cs" Inherits="PhotoApplication.drag.uploads" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <script type="text/javascript">

       $(function () {

           var aidm = '<%= Session["aidm"] %>';

           $(".closeTab").on("click", function () {
               window.top.close();
           });
           

           $('#uPhoto').attr('src', 'data:image/png;base64,' + 'iVBORw0KGgoAAAANSUhEUgAAAMEAAADBCAIAAAD5IEPLAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAABkiSURBVHhe7Z3fixzlmscHhHMjhoS9NKyBxYtwLgwrBI+ghCUouYs5CCKIcW+88AfJol7IIlEQPBdCDqIoYcHoAQlemES8EXRdBclkTWa6Z3p6uqdn+ud0T89kZtyMf8B+pr7vvFS6e2aqu6u7q6rfD01T9U51T9X7fup5nrf618TvDkd/OIcc/eIccvSLc8jRL84hR7/06FA2m7106dILL7xw+fJl0+RIFq+//vr58+evXLlSqVRM0y504dDs7CzePPfccw899NDEDvybnxxJ5LHHHjNjPDHx6KOPotRXX33V0acODq2vr5ulHWgh3pw6derQoUPmWXc4fPjwMUcSOXDggBnjHRhrIsivv/5qtNihg0MXL140S53A0Pfee+/pp5/W//jwww/NHxzJgiGWN88+++ynn35KFjJ/aKPVoZWVlYcfftis7McPP/xw48YNs+JIFt99910qlTIre9Lq0PXr17FvD+nizunTp7fj8sTE2bNnS6WSae3EuXPnCOlmxbE7rQ698cYb9C+xy6wnDo7uxIkTBw8e1IJp7QQ5HY3MimN3Wh1SNf7888+b9cSh2MP9kSNHONLp6Wm1O3rmHocohv70pz/Rs8zeTVNyIcZwpFevXjXrjl65xyEVQyLBJZG4cOECh9mVQwStlu1ZZaJqVsaVexxSMSQuXbpkWhMKNTWHWS6XNzc3NzwqlUo+n1/Y4fHHH3/iiSf0V7akGFcVxYKegYp7u6cmJt59993/20F/Givuceibb76hkDx06BD333//vWlNInfv3qUeeuSRR+7cuYMuc3NzuVwuk8ncvHnzf3c4fvw41SHtS0tLiIJAly9ffumll1j++eefr127xsI777zzXx48D2AbzzxuJrXW1HD48GGzlEQULX777TcMePPNN0nZt27dsurQbsEhmJycnJmZYeO33nprbW3t66+/Zpl7zjEWzp8/zzNYqtVqs9lks7EyabwcYlwJFY1G4+WXX8aAb7/9FkWMMm3IIRZwS7og02effcYy96lUiij1wAMPELxRULABNdP8/Hy9Xl9fX9/a2jL/ONGMkUPEBoaWAohMdODA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');

           /*
           phoenix3\pg_app_uploads
           phoenix3\ug_app_uploads
           */

           //aidm = '77817';

           var $form = $('.box');

           $('body').on('dragover drop', function (e) { e.preventDefault(); });
           $(document).on('draginit dragstart dragover dragend drag drop', function (e) {
               e.stopPropagation();
               e.preventDefault();
           });

           function makeDroppable(element, callback, docType) {

               var input = document.createElement('input');
               input.setAttribute('type', 'file');
               input.setAttribute('id', docType);
               input.setAttribute('multiple', true);
               input.style.display = 'none';

               //input.addEventListener('change', triggerCallback);
               input.addEventListener('change', function (e) {

                   triggerCallback(e, docType);
               });

               element.appendChild(input);

               element.addEventListener('dragover', function (e) {
                   e.preventDefault();
                   e.stopPropagation();

                   element.classList.add('dragover');
               });

               element.addEventListener('dragleave', function (e) {

                   e.preventDefault();
                   e.stopPropagation();
                   element.classList.remove('dragover');
               });

               element.addEventListener('drop', function (e) {
                   e.preventDefault();
                   e.stopPropagation();
                   element.classList.remove('dragover');
                   triggerCallback(e, docType);
               });

               element.addEventListener('click', function (e) {
                   input.value = null;
                   input.click();
                   console.log("input = " + input.value);


                   //triggerCallback(e, docType);
               });

               function triggerCallback(e, docType) {

                   var files;

                   if (e.dataTransfer) {

                       files = e.dataTransfer.files;

                   } else if (e.target) {

                       files = e.target.files;
                       console.log("Files = " + files);

                   }

                   if (e.target.files == undefined) {
                       fileName = e.dataTransfer.files[0].name;
                   } else {
                       fileName = e.target.files[0].name;
                   }



                   callback.call(null, files, docType);

               }
           }

           function displayFileName(docType) {

               if (docType == "photo") {

                   $(".lblphotofilename").text(fileName + " Uploaded Successfully.");

               } else if (docType == "transcript") {

                   $(".lbltranscriptfilename").text(fileName + " Uploaded Successfully.");

               } else if (docType == "BirthCertificate") {

                   $(".lblbirthcertfilename").text(fileName + " Uploaded Successfully.");

               } else if (docType == "CV") {

                   $(".lblCVfilename").text(fileName + " Uploaded Successfully.");

               } else if (docType == "ReferenceLetter") {

                   $(".lblReferenceLetterfilename").text(fileName + " Uploaded Successfully.");

               } else if (docType == "Other") {

                   $(".lblOtherfilename").text(fileName + " Uploaded Successfully.");

               }

           }

           function waitFunction(docType) {
               if (docType == "photo") {

                   $(".lblphotofilename").text("Waiting...");

               } else if (docType == "transcript") {

                   $(".lbltranscriptfilename").text("Waiting...");

               } else if (docType == "BirthCertificate") {

                   $(".lblbirthcertfilename").text("Waiting...");

               } else if (docType == "CV") {

                   $(".lblCVfilename").text("Waiting...");

               } else if (docType == "ReferenceLetter") {

                   $(".lblReferenceLetterfilename").text("Waiting...");

               } else if (docType == "Other") {

                   $(".lblOtherfilename").text("Waiting...");

               }
           }
           function callback(files, docType) {
               var formData = new FormData();

               waitFunction(docType);
               $.each(files, function (i, file) {

                   formData.append('drpfile', file);

               });


               $('.iPhoto').attr('width', '193px');
               $('.iPhoto').attr('height', '193px');



               $.ajax({
                   url: '../services/Photo.ashx?id=' + aidm + '&docType=' + docType,
                   type: 'POST',
                   data: formData,
                   processData: false,
                   contentType: false,
                   success: function (response) {



                       if (response.indexOf('error') == -1) {



                           displayFileName(docType);
                           swal("Success", "Files uploaded successfully.", "success");

                       } else {

                           swal("Error", response, "error");

                       }
                       if (docType == 'photo') {

                           $('#uPhoto').attr('src', 'data:image/png;base64,' + response);
                       }
                   }
               });

           }


           var element = document.querySelector('.droppable');
           var elementTranscript = document.querySelector('.droppableTranscript');
           var elementCV = document.querySelector('.droppableCV');
           var elementOther = document.querySelector('.droppableOther');
           var elementBirthCertificate = document.querySelector('.droppableBirthCertificate');
           var elementReferenceLetter = document.querySelector('.droppableReferenceLetter');


           makeDroppable(element, callback, "photo");
           makeDroppable(elementTranscript, callback, "transcript");
           makeDroppable(elementCV, callback, "CV");
           makeDroppable(elementOther, callback, "Other");
           makeDroppable(elementBirthCertificate, callback, "BirthCertificate");
           makeDroppable(elementReferenceLetter, callback, "ReferenceLetter");

       });

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">

   <br/><br/><br/><br/><br/><br/>
   <div id="uploadContainer" class="center">
     
      <input type="file" id="FileUpload1" style="display: none" />

      <div class="photoHeader">
          
          <div style="float:left;margin:2px;position:relative; top:10px;">
            <img src="../images/logo.png" alt="" style="position:relative;top:29px;" />
          </div>
          <div style="float:right;margin:10px;position:relative; top:0px;">
             <img alt="" id="uPhoto" class="iPhoto" style="border-radius:5px;border:0px solid #B3B4B5;" />
             
          </div>
          
      </div>
     
      <div class="docPanel">
         
       <div style="position:relative;float:left;clear:both;margin:5px;top:-3px;">
          <span class="instructlbl">ID Photograph</span>
       </div>

       <div class="droppable" id="photo" style="background:#DEDEDE;width:97%;height:40px;position:relative;clear:both;float:left;margin:5px;top:-15px;cursor:pointer;border-radius:3px;">
           <div style="position:relative;float:left;margin:5px;"> 
             <span><img alt="" src="../images/newupload.png" /></span>
           </div>
           <div style="position:relative;float:left;margin:5px;top:3px;"> 
             <span>or drag files here</span>
           </div>
       </div>
       <div style="position:relative;float:left;clear:both;margin:5px;top:-24px;z-index:10;color:#000;width:300px; height:35px;">
              <span class="lblphotofilename" style="width:300px; height:35px;"></span>
        </div>
       
    
      </div>
      
    
      <div class="docPanel">
         
        <div style="position:relative;float:left;clear:both;margin:5px;top:-3px;">
          
          <span class="instructlbl">Transcript</span>
          
        </div>
        
        <div class="droppableTranscript" style="background:#DEDEDE;width:97%;height:40px;position:relative;clear:both;float:left;margin:5px;top:-15px;cursor:pointer;border-radius:3px;">
           <div style="position:relative;float:left;margin:5px;"> 
              <img alt="" src="../images/newupload.png" />
          </div>
          <div style="position:relative;float:left;margin:5px;top:3px;"> 
             <span>or drag files here</span>
           </div> 
         </div>
         <div style="top:60px;position:relative;float:left;clear:both;margin:5px;top:-24px;z-index:10;color:#000;width:300px; height:35px;">
          <span class="lbltranscriptfilename"></span>
        </div>

      </div>
      
       <div class="docPanel">
         
        <div style="position:relative;float:left;margin:5px;top:-3px;">
          <span class="instructlbl">Birth Certificate</span>
        </div>

         <div class="droppableBirthCertificate" style="background:#DEDEDE;width:97%;height:40px;position:relative;clear:both;float:left;top:-15px;margin:5px;cursor:pointer;border-radius:3px;">
           <div style="position:relative;float:left;margin:5px;top:3px;"> 
              <img alt="" src="../images/newupload.png" />
           </div>
            <div style="position:relative;float:left;margin:5px;top:3px;"> 
             <span>or drag files here</span>
           </div>
         </div>
         <div style="top:60px;position:relative;float:left;clear:both;margin:5px;top:-24px;z-index:10;color:#000;width:600px; height:35px;">
            <span class="lblbirthcertfilename"></span>
         </div>
      </div>
       
      <div class="docPanel">
         
        <div style="position:relative;float:left;margin:5px;top:-3px;">
           <span class="instructlbl">CV</span>
        </div>

         <div class="droppableCV" style="background:#DEDEDE;width:97%;height:40px;position:relative;clear:both;float:left;top:-15px;margin:5px;cursor:pointer;border-radius:3px;">
           <div style="position:relative;float:left;margin:5px;top:3px;"> 
              <img alt="" src="../images/newupload.png" />
           </div>
           <div style="position:relative;float:left;margin:5px;top:3px;"> 
             <span>or drag files here</span>
           </div>
         </div>
         <div style="top:60px;position:relative;float:left;clear:both;margin:5px;top:-24px;z-index:10;color:#000;width:600px; height:35px;">
            <span class="lblCVfilename"></span>
         </div>
      </div>
      
      <div class="docPanel">
         
        <div style="position:relative;float:left;margin:5px;top:-3px;">
          <span class="instructlbl">Reference Letter</span>
        </div>

         <div class="droppableReferenceLetter" style="background:#DEDEDE;width:97%;height:40px;position:relative;clear:both;float:left;top:-15px;margin:5px;cursor:pointer;border-radius:3px;">
           <div style="position:relative;float:left;margin:5px;top:3px;"> 
              <img alt="" src="../images/newupload.png" />
           </div>
           <div style="position:relative;float:left;margin:5px;top:3px;"> 
             <span>or drag files here</span>
           </div>
         </div>
         <div style="top:60px;position:relative;float:left;clear:both;margin:5px;top:-24px;z-index:10;color:#000;width:600px; height:35px;">
            <span class="lblReferenceLetterfilename"></span>
         </div>
      </div>
      
      <div class="docPanel">

         <div style="position:relative;float:left;margin:5px;top:-3px;">
           <span class="instructlbl">Any Other Document</span>
          </div> 

          <div class="droppableOther" style="background:#DEDEDE;width:97%;height:40px;position:relative;clear:both;float:left;top:-15px;margin:5px;cursor:pointer;border-radius:3px;">
          
           <div style="position:relative;float:left;margin:5px;top:3px;"> 
             <img alt="" src="../images/newupload.png" />
           </div>
           <div style="position:relative;float:left;margin:5px;top:3px;"> 
             <span>or drag files here</span>
           </div>

         </div>
         <div style="top:60px;position:relative;float:left;clear:both;margin:5px;top:-24px;z-index:10;color:#000;width:600px; height:35px;">
            <span class="lblOtherfilename"></span>
         </div>
      </div>
      
      <div style="position:relative;float:right;margin:10px;top:-30px;">
           <button class="closeTab text" style="width:120px;height:35px;border-radius:5px;color:Maroon" >CLOSE</button>
      </div>
       

    
   </div>

</asp:Content>
