<%@ Page Title="" Language="C#" MasterPageFile="~/Photo.Master" AutoEventWireup="true" CodeBehind="draggable.aspx.cs" Inherits="PhotoApplication.drag.draggable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<script type="text/javascript">



    $(function () {

        /*\\phoenix3\pg_app_uploads*/
        /*\\phoenix3\ug_app_uploads*/


        var aidm = '<%= Session["aidm"] %>';


        var $form = $('.box');

        $input = $(".box__file");
        $label = $(".filelbl");


        $('body').on('dragover drop', function (e) { e.preventDefault(); });
        $(document).on('draginit dragstart dragover dragend drag drop', function (e) {
            e.stopPropagation();
            e.preventDefault();
        });

        showFiles = function (files) {

            //$label.text(files.length > 1 ? ($input.attr('data-multiple-caption') || '').replace('{count}', files.length) : files[0].name);

        }

        $input.on('change', function (e) {
            showFiles(e.target.files);

            droppedFiles = e.target.files;
            processFiles();

        });


        var isAdvancedUpload = function () {
            var div = document.createElement('div');
            return (('draggable' in div) || ('ondragstart' in div && 'ondrop' in div)) && 'FormData' in window && 'FileReader' in window;
        } ();







        if (isAdvancedUpload) {


            var droppedFiles = false;

            $form.on('drag dragstart dragend dragover dragenter dragleave drop', function (e) {

                e.preventDefault();
                e.stopPropagation();
                $(".box__dragndrop").show();
            })
           .on('dragover dragenter', function () {

               //$form.addClass('.box.is-dragover');
               $(".box__input").css({ 'background-color': '#8C8C8C' });
           })
           .on('dragleave dragend drop', function () {
               //$form.removeClass('is-dragover');
               $(".box__input").css({ 'background-color': '#E4E7EE' });
           })
           .on('drop', function (e) {

               droppedFiles = e.originalEvent.dataTransfer.files;
               showFiles(droppedFiles);
               processFiles();


           });


        }


        var processFiles = function () {



            var ajaxData = new FormData($form.get(0));



            if (droppedFiles) {


                $.each(droppedFiles, function (i, file) {


                    ajaxData.append($input.attr('name'), file);


                });
            }


            $.ajax({
                url: '../services/Photo.ashx?id=' + aidm,
                data: ajaxData,
                processData: false,
                contentType: false,
                type: 'POST',
                success: OnComplete,
                error: OnFail
            });




        }

        function OnComplete(result) {

            console.log(result);

            result = (result.substring(6, result.length));



            if (result != 'error') {

                var fil = result;

                //(result.substring(6, result.length))

                var extension = fil.split('.').pop();

                if ((extension == "png") || (extension == "jpg")) {


                    var my_path = "../uploaded/" + fil;


                    $("#iPhoto").attr("src", my_path);

                    alert('File Successfully Saved');

                } else if (extension == "pdf") {

                    alert('File Successfully Saved');

                }

            } else {
                var my_path = "../images/photofiller.png";
                $("#iPhoto").attr("src", my_path);
                alert(result + "; Check your file type or dimensions");
            }
        }

        function OnFail(result) {

            console.log(result);

            var my_path = "../images/photofiller.png";
            $("#iPhoto").attr("src", my_path);
            alert('Request failed ');
        }


        function sendFile() {


            var ajaxData = new FormData($form.get(0));
            if (droppedFiles) {
                $.each(droppedFiles, function (i, file) {
                    ajaxData.append($input.attr('name'), file);
                });
            }

            $.ajax({
                type: 'post',
                url: 'Photo.ashx',
                data: ajaxData,
                success: function (status) {
                    if (status != 'error') {
                        var my_path = "uploaded/" + status;
                        $("#iPhoto").attr("src", my_path);
                    }
                },
                processData: false,
                contentType: false,
                error: function () {
                    alert("Whoops something went wrong!");
                }
            });
        }


        $("#iPhoto").on('change', function () {

            // var file, img;
            //   if ((file = this.files[0])) {
            img = new Image();
            img.onload = function () {
                sendFile();

            };
            img.onerror = function () {
                alert("Not a valid file:" + file.type);
            };
            img.src = _URL.createObjectURL(file);
            // }
        });


    });


</script>

 

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

   

      <div align="center">
      
      <asp:Label ID="Label2" runat="server" Text="Drop Image(jpg) Or PDF files" Font-Names="Verdana" Font-Size="30pt"></asp:Label>
      
     <!--
     <label for="Radio1" title="Image" >
         <input id="Radio1" type="radio" name="docType" value"image" />Image
     </label>

     <label for="Radio1" title="Image">
        <input id="Radio2" type="radio" name="docType" value"pdf"/>PDF
     </label>
     -->

    </div>






    <div id="photoTag">
        <center>
        <asp:Label ID="Label1" runat="server" Text="2 ins * 2 ins/193pixels * 193pixels" Font-Size="12pt" ForeColor="#fff"></asp:Label>
        <img alt="" id="iPhoto" src="../images/photofiller.png" width="193px" height="193px"/>
        </center>
    </div> 

    <div class="box__input">
        
        <!--<label for="file" class="filebuttonlbl" title="Choose a file">
           <input class="box__file" type="file" name="files[]" id="file" data-multiple-caption="{count} files selected" multiple />
        </label>  -->
        <label for="file" class="filelbl"></label>
            <span class="box__dragndrop"> <img src="../images/bucket.png"/></span>.
        
        <!--<button class="box__button" type="submit">Upload</button>-->

    </div>
    <div class="box__uploading">Uploading</div>
    <div class="box__success">Done!</div>
    <div class="box__error">Error! <span></span>.</div>
   
   

    <!--
      <div id="dragandrophandler">
      
        
    <input class="box__file" type="file" name="files[]" id="file" data-multiple-caption="{count} files selected" multiple />
    <label for="file"><strong>Choose a file</strong><span class="box__dragndrop"> or drag it here</span>.</label>

      
     </div>
     -->
  
</asp:Content>
