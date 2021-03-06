# AsposeThreeDCloud::Object::PlySaveOption

## Load the model package
```perl
use AsposeThreeDCloud::Object::PlySaveOption;
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**save_format** | [**SaveFormat**](SaveFormat.md) | Gets or sets  of the SaveFormat. | [optional] 
**lookup_paths** | **ARRAY[string]** | Some files like OBJ depends on external file, the lookup paths will allows Aspose.3D to look for external file to load | [optional] 
**file_name** | **string** | The file name of the exporting/importing scene. This is optional, but useful when serialize external assets like OBJ&#39;s material. | [optional] 
**file_format** | **string** | The file format like FBX,U3D,PDF .... | [optional] 
**flip_coordinate** | **boolean** | Flip the coordinate while saving the scene, default value is true. | [optional] 
**vertex_element** | **string** | The element name for the vertex data, default value is \&quot;vertex\&quot;. | [optional] 
**position_components** | **ARRAY[string]** | The component names for position data, default value is (\&quot;x\&quot;, \&quot;y\&quot;, \&quot;z\&quot;) | [optional] 
**face_element** | **string** | The element name for the face data, default value is face. | [optional] 
**face_property** | **string** | The property name for the face data, default value is vertex_index. | [optional] 
**file_content_type** | [**FileContentType**](FileContentType.md) | Gets or sets  of the FileContent Style. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


