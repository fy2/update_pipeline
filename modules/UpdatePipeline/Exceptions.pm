package UpdatePipeline::Exceptions;

use Exception::Class (
    UpdatePipeline::Exceptions::UnknownCommonName         => { description => 'The sample has a common name which is not in our list of valid names' },
    UpdatePipeline::Exceptions::CouldntCreateProject      => { description => 'Couldnt create a row in VRTrack for project' },
    UpdatePipeline::Exceptions::CouldntCreateLibrary      => { description => 'Couldnt create a row in VRTrack for library' },
    UpdatePipeline::Exceptions::CouldntCreateSample       => { description => 'Couldnt create a row in VRTrack for sample' },
    UpdatePipeline::Exceptions::CouldntCreateStudy        => { description => 'Couldnt create a row in VRTrack for study' },
    UpdatePipeline::Exceptions::CouldntCreateLane         => { description => 'Couldnt create a row in VRTrack for lane' },
    UpdatePipeline::Exceptions::CouldntCreateFile         => { description => 'Couldnt create a row in VRTrack for file' },
    UpdatePipeline::Exceptions::FileMD5Changed            => { description => 'MD5 of file has changed, need to reimport and reprocess' },
    UpdatePipeline::Exceptions::TotalReadsMismatch        => { description => 'Total reads differs, usually an error in the import' },
    UpdatePipeline::Exceptions::UndefinedSampleName       => { description => "undefined sample name in irods"},
    UpdatePipeline::Exceptions::UndefinedSampleCommonName => { description => "undefined sample common name in irods"},
    UpdatePipeline::Exceptions::UndefinedStudySSID        => { description => "undefined study ssid in irods"},
    UpdatePipeline::Exceptions::UndefinedLibraryName      => { description => "undefined library name in irods"},
    UpdatePipeline::Exceptions::PathToLaneChanged         => { description => "path has changed so need to reimport"},
    UpdatePipeline::Exceptions::DuplicateLibraryName      => { description => "Dupicate library name, only happens in old samples"},
    UpdatePipeline::Exceptions::CommandFailed             => { description => "External command returned non-zero exit status" },
    UpdatePipeline::Exceptions::FileNotFound              => { description => "File not found in VRTrack file system" },
);  

1;
