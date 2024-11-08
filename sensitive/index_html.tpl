{{ with secret \"transit/export/encryption-key/my_key\" }}
{{ if .Data.keys }}
<html>
<head>
</head>
<body>
<h1>envelope_encryption_transit:{{ index .Data.keys \"1\" }}</h1>
</body>
</html>
{{ end }}
{{ end }}