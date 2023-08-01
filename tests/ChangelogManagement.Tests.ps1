BeforeAll {
    $ProjectRoot = Split-Path $PSScriptRoot -Parent
    $ModuleManifestPath = $(Get-ChildItem -Path (Join-Path $ProjectRoot "src") -Filter "*.psd1").FullName
}

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}