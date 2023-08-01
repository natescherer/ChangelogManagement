BeforeAll {
    $Separator = [IO.Path]::DirectorySeparatorChar
    $ModuleManifestPath = $PSCommandPath.Replace("$($Separator)tests$($Separator)", "$($Separator)src$($Separator)").Replace(".Tests.ps1", ".psd1")
}

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}