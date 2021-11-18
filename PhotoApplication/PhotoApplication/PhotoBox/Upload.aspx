<%@ Page Title="" Language="C#" MasterPageFile="~/Photo.Master" AutoEventWireup="true" CodeBehind="Upload.aspx.cs" Inherits="PhotoApplication.PhotoBox.Upload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

     <script type="text/javascript">

         $(function () {


             //


             var isAdvancedUpload = function () {

                 var div = document.createElement('div');
                 return (('draggable' in div) || ('ondragstart' in div && 'ondrop' in div)) && 'FormData' in window && 'FileReader' in window;
             } ();

             var fd = new window.FormData();

             if (isAdvancedUpload) {

                 $form = $('#form1');



                 var droppedFiles = false;

                 $form.on('drag dragstart dragend dragover dragenter dragleave drop', function (e) {
                     alert('test');
                     e.preventDefault();
                     e.stopPropagation();
                 })
                 .on('dragover dragenter', function () {


                     $form.addClass('is-dragover');
                 })
                 .on('dragleave dragend drop', function () {
                     $form.removeClass('is-dragover');
                 })
                 .on('drop', function (e) {


                     droppedFiles = e.originalEvent.dataTransfer.files;
                     fd.append('file', droppedFiles);

                     $.ajax({
                         url: 'services/Photo.ashx',
                         data: fd,
                         processData: false,
                         contentType: "application/json; charset=utf-8",
                         type: 'POST',
                         success: OnComplete,
                         error: OnFail
                     });

                 });

                

             }

             


             function OnComplete(result) {
                 alert('Success');
             }

             function OnFail(result) {
                 alert('Request failed');
             }


         });

  </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <br/><br/> 
    <!--<div id="dragandrophandler">Drag & Drop Files Here New</div>--->

</asp:Content>
