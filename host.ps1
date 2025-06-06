# Pokreni kao administrator
$drive = "C:"

# Proveri da li postoji USN Journal
fsutil usn queryJournal $drive

# Ako postoji, brišemo ga
Write-Host "Brisanje USN Journal-a sa diska $drive ..." -ForegroundColor Yellow
fsutil usn deleteJournal /D $drive

Write-Host "USN Journal je obrisan sa diska $drive." -ForegroundColor Green