$root = "."
$jsPath = "$root\assets\index-BBIwAgSn.js"
$c = [System.IO.File]::ReadAllText($jsPath, [System.Text.Encoding]::UTF8)

$checks = @(
    "Rang Jo Lagyo",
    "Tal Se Taal Mila",
    "A Journey of Two Souls",
    "Saat Phere",
    "Wedding Events",
    "Dhanya & Rahul",
    "2026-09-13T10:00:00"
)

foreach ($s in $checks) {
    if ($c.Contains($s)) {
        Write-Host "FOUND: $s"
    } else {
        Write-Host "NOT FOUND: $s"
    }
}
