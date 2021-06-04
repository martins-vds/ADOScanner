Set-StrictMode -Version Latest

class SVTResourceResolverHelper {
    [string] $ResourceType = "";
    [ResourceTypeName] $ResourceTypeName = [ResourceTypeName]::All;

    [string] $organizationName

    SVTResourceResolverHelper($organizationName) {
        $this.organizationName = $organizationName;
    }

    [SVTResource[]] LoadResourcesForScan($projectName, $repoNames, $artifactNames, $feedNames, $ResourceTypeName) {
        #Get resources    
        [SVTResource[]] $SVTResources = @();
        if ($repoNames.Count -gt 0 -or $ResourceTypeName -eq [ResourceTypeName]::Repository) {
            #Write-Host "Getting repository configurations..." -ForegroundColor cyan
            if ($ResourceTypeName -eq [ResourceTypeName]::Repository -and $repoNames.Count -eq 0) {
                $repoNames += $this.ConvertToStringArray("*");
            }
            $objRepos = @();
            $objRepos += $this.FetchRepositories($projectName, $repoNames);
            if ($objRepos -and $objRepos.count -gt 0) {
                foreach ($repos in $objRepos) {
                    $resourceId = "organization/{0}/project/{1}/repository/{2}" -f $this.organizationName, $projectName, $repos.id;
                    $SVTResources += $this.AddSVTResource($repos.name, $projectName, "ADO.Repository", $resourceId, $repos, $repos.webUrl);
                }
                $objRepos = $null;
            }
        }
        
        ##Get artifactes
        #if ($artifactNames.Count -gt 0 ) {
        #    # Here we are fetching all the feeds in the project and then filtering out.
        #    $resourceId = "organization/{0}/project/{1}/artifact/{2}" -f $this.organizationName, $projectName, "12345";
        #    $SVTResources += $this.AddSVTResource("artifact", $projectName, "ADO.Artifact", $resourceId, $null, "");
        #}

        #Get feeds
        if ($feedNames.Count -gt 0 -or $ResourceTypeName -eq [ResourceTypeName]::Feed) {
            #Write-Host "Getting feed configurations..." -ForegroundColor cyan
            if ($ResourceTypeName -eq [ResourceTypeName]::Feed -and $feedNames.Count -eq 0) {
                $feedNames += "*"
            }
            $objFeeds = $this.FetchFeeds($projectName, $feedNames);
            if ($objFeeds -and $objFeeds.count -gt 0) {
                foreach ($feed in $objFeeds) {
                    if ([Helpers]::CheckMember($feed, "id")) {
                        $resourceId = "organization/{0}/project/{1}/feed/{2}" -f $this.organizationName, $projectName, $feed.id;
                        $SVTResources += $this.AddSVTResource($feed.name, $projectName, "ADO.Feed", $resourceId, $feed, $feed.Url);
                    }
                }
                $objFeeds = $null;
            }
        }

        return $SVTResources;
    }

    hidden [PSObject] FetchRepositories($projectName, $repoNames) {
        try {
            # Here we are fetching all the repositories in the project and then filtering out.
            $repoDefnURL = "";
            $repoDefnURL = "https://dev.azure.com/$($this.organizationName)/$projectName/_apis/git/repositories?api-version=6.1-preview.1"
            $repoDefnsObj = [WebRequestHelper]::InvokeGetWebRequest($repoDefnURL);
            if ($repoNames -ne "*") {
                $repoDefnsObj = $repoDefnsObj | Where-Object { $repoNames -contains $_.name }
            }

            return $repoDefnsObj;
        }
        catch {
            return $null;
        }
    }

    hidden [PSObject] FetchFeeds($projectName, $feedNames) {
        try {
            # Here we are fetching all the feeds in the project.
            $feedDefnURL = 'https://feeds.dev.azure.com/{0}/{1}/_apis/packaging/feeds?api-version=6.0-preview.1' -f $this.organizationName, $projectName
            $feedDefnsObj = [WebRequestHelper]::InvokeGetWebRequest($feedDefnURL);
            if ($feedNames -ne "*") {
                $feedDefnsObj = $feedDefnsObj | Where-Object { $feedNames -contains $_.name }
            }

            return $feedDefnsObj;
        }
        catch {
            return $null;
        }
    }

    [SVTResource] AddSVTResource([string] $name, [string] $resourceGroupName, [string] $resourceType, [string] $resourceId, [PSObject] $resourceDetailsObj, $resourceLink)
    {
        $svtResource = [SVTResource]::new();
        $svtResource.ResourceName = $name;
        if ($resourceGroupName) {
            $svtResource.ResourceGroupName = $resourceGroupName;
        }
        $svtResource.ResourceType = $resourceType;
        $svtResource.ResourceId = $resourceId;
        $svtResource.ResourceTypeMapping = ([SVTMapping]::AzSKADOResourceMapping | Where-Object { $_.ResourceType -eq $resourceType } | Select-Object -First 1)

        if ($resourceDetailsObj) {
            $svtResource.ResourceDetails = $resourceDetailsObj;
            $svtResource.ResourceDetails | Add-Member -Name 'ResourceLink' -Type NoteProperty -Value $resourceLink;
        }
        else {
            $svtResource.ResourceDetails = New-Object -TypeName psobject -Property @{ ResourceLink = $resourceLink }
        }                         
                                        
        return $svtResource;
    }
}
