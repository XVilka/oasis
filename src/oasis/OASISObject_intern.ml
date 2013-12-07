
open OASISGettext
open OASISTypes
open OASISSchema_intern
open PropList.Field
open OASISValues


let schema, generator =
  let schm =
    schema "Object" (fun (cs, _, _) -> cs.cs_plugin_data)
  in
  let cmn_section_gen =
    OASISSection_intern.section_fields
      (fun () -> (s_ "object"))
      schm
      (fun (cs, _, _) -> cs)
  in
  let build_section_gen =
    OASISBuildSection_intern.section_fields
      (fun () -> (s_ "object"))
      Best
      schm
      (fun (_, bs, _) -> bs)
  in
  let modules =
    new_field schm "Modules"
      ~default:[]
      ~quickstart_level:Beginner
      modules
      (fun () ->
         s_ "List of modules to compile.")
      (fun (_, _, obj) -> obj.obj_modules)
  in
  let findlib_fullname =
    new_field schm "FindlibFullName"
      ~default:None
      (* TODO: Check that the name is correct if this value is None, the
               package name must be correct
       *)
      (opt (dot_separated findlib_name))
      (fun () ->
         s_ "Name used by findlib.")
      (fun (_, _, obj) -> obj.obj_findlib_fullname)
  in
    schm,
    (fun features_data nm data ->
       OASISFeatures.data_assert
         OASISFeatures.section_object
         features_data
         (OASISFeatures.Section "Object");
       Object
         (cmn_section_gen features_data nm data,
          (build_section_gen nm data),
          {
            obj_modules            = modules data;
            obj_findlib_fullname   = findlib_fullname data;
          }))

