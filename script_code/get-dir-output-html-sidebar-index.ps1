# Get the directory listing
$currentLocation = (Get-Location).Path
$items = Get-ChildItem -Path '.\' -File -Recurse -Exclude "home.html","styles.css","scripts.js","index.html","get-dir-output-html-sidebar-index.ps1",*.doc,*.docx,*.xls,*.xlsx,*.csv

$homepage = ".\home.html"

$htmlRows = foreach ($item in $items) {
    $name = $item.BaseName
    $fullPath = $item.FullName
    #$relativePath = $fullPath -replace [regex]::Escape($currentLocation.Path), ""
    $relativePath = $fullPath.Substring($currentLocation.Length)
    $relativePath = $relativePath -replace "\\", "/"
    #Write-Output $relativePath
        $link = "<a href='.$relativePath' target='iframe_a' target='_Parent'>$name</a>" # GOOD FOR WITHOUT WEB SERVER
    
    
   # "<tr><td>$link</td><td>$($_.LastWriteTime)</td><td>$($_.Length)</td></tr>"
  "<li>$link</li>"
}

# Convert each item to an HTML table row with a hyperlink
# $htmlRows = $items | ForEach-Object {
#     $name = $_.Name
#     $fullName = $_.FullName

#     Write-host " $relativePath"
#     #$link = "<a href='file:///$fullName' target='iframe_a' target='_Parent'>$name</a>" # GOOD FOR WITHOUT WEB SERVER
#     $link = "<a href='SourceFiles\exam\$name' target='iframe_a' target='_Parent'>$name</a>" # GOOD FOR WITHOUT WEB SERVER
    
    
#    # "<tr><td>$link</td><td>$($_.LastWriteTime)</td><td>$($_.Length)</td></tr>"
#   "<li>$link</li>"
# }

# Build the complete HTML content
$htmlContent = @"
<!DOCTYPE html>
<html>
<!--  https://www.w3schools.com/howto/howto_css_fixed_sidebar.asp -->
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body {
      font-family: "Lato", sans-serif;
    }

    /* ADD BY RS */
    .logo {
      font-family: system-ui;
      /* font-family: "Console", "Courier New", monospace; */
      font-size: 22px;
      text-align: center;
      color: orangered;
      background-color: black;
      font-weight: bold;
    }
    .sidenav {
      height: 100%;
      width: 220px;
      position: fixed;
      z-index: 1;
      top: 0;
      left: 0;
      background-color: lightgray;
      overflow-x: hidden;
      padding-top: 20px;
    }

/* a parameter not required */
/* START */
/*   
    .sidenav a {
      padding: 6px 8px 6px 16px;
      text-decoration: none;
      font-size: 14px;
      color: #818181;
      display: block;
    }

    .sidenav a:hover {
      color: #f1f1f1;
    }

*/
/* a parameter not required */
/* END */

    .main {
      margin-left: 220px;
      /* Same as the width of the sidenav */
      font-size: 14px;
      /* Increased text to enable scrolling */
      padding: 0px 10px;
    }

    @media screen and (max-height: 450px) {
      .sidenav {
        padding-top: 15px;
      }

      .sidenav a {
        font-size: 14px;
      }
    }


/* https://www.w3schools.com/howto/howto_js_filter_lists.asp */
/* START */

* {
  box-sizing: border-box;
}

#myInput {
  background-image: url('/css/searchicon.png');
  background-position: 10px 12px;
  background-repeat: no-repeat;
  width: 100%;
  font-size: 13px;
  padding: 12px 20px 12px 40px;
  border: 3px solid #ddd;
  margin-bottom: 12px;
}

#myUL {
  list-style-type: none;
  padding: 0;
  margin: 0;
}

#myUL li a {
  border: 1px solid #ddd;
  margin-top: -1px; /* Prevent double borders */
  background-color: #f6f6f6;
  padding: 7px;
  text-decoration: none;
  font-size: 12px;
  font-family: Verdana, sans-serif;
  color: black;
  display: block;
}

#myUL li a:hover:not(.header) {
  background-color: #eee;
}

/* https://www.w3schools.com/howto/howto_js_filter_lists.asp */
/* END */

  </style>
</head>

<body>

  <div class="sidenav">

    <div class="logo">RoboticScript</div>
    <hr>

<!-- https://www.w3schools.com/howto/howto_js_filter_lists.asp -->
<!-- START -->


<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name">

<ul id="myUL">

$htmlRows

  &nbsp;
  &nbsp;

</ul>

<!-- https://www.w3schools.com/howto/howto_js_filter_lists.asp -->
<!-- END -->

  </div>

  <div class="main">
    <h2>WELCOME</h2>
    <iframe src="$homepage" name="iframe_a" width="100%" height="600px" style="border:2px solid lightgray;background-color: #F3F3F3;" title="Iframe Example"></iframe>
  </div>

<!-- https://www.w3schools.com/howto/howto_js_filter_lists.asp -->
<!-- START -->

  <script>
    function myFunction() {
        var input, filter, ul, li, a, i, txtValue;
        input = document.getElementById("myInput");
        filter = input.value.toUpperCase();
        ul = document.getElementById("myUL");
        li = ul.getElementsByTagName("li");
        for (i = 0; i < li.length; i++) {
            a = li[i].getElementsByTagName("a")[0];
            txtValue = a.textContent || a.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                li[i].style.display = "";
            } else {
                li[i].style.display = "none";
            }
        }
    }
    </script>

<!-- https://www.w3schools.com/howto/howto_js_filter_lists.asp -->
 <!-- END -->

</body>

</html>

"@

# Specify the output file path
$outputFilePath = ".\index.html"

# Save the HTML content to the file
$htmlContent | Out-File -FilePath $outputFilePath -Encoding utf8

Write-Output "HTML file created at $outputFilePath"
