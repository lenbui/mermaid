-- SPDX-License-Identifier: LPPL-1.3c+

require "lfs"

-- @param mode directly passed to Mermaid. 
function convertToDiagram(jobname)
  local MmdSourceFilename = jobname .. "mmd.in"
  local MmdTargetFilename = jobname .. "mmd.pdf"

  -- delete generated file to ensure they are really recreated
  os.remove(MmdTargetFilename)

  if not (lfs.attributes(MmdSourceFilename)) then
    texio.write_nl("Source " .. MmdSourceFilename .. " does not exist.")
    return
  end

  texio.write("Executing Mermaid.js ... ")
  local cmd = "mmdc -f -i " .. MmdSourceFilename .. " -o " .. MmdTargetFilename
  texio.write_nl(cmd)
  local handle,error = io.popen(cmd)
  if not handle then
    texio.write_nl("Error during execution of Mermaid.")
    texio.write_nl(error)
    return
  end
  io.close(handle)

  if not (lfs.attributes(MmdTargetFilename)) then
    texio.write_nl("Mermaid did not generate anything.")
    handle = io.open(MmdTargetFilename, "w")
    handle:write("Error during latex code generation")
    io.close(handle)
    return
  end
end