function get_file_modification_time(file)
    -- PowerShell command to get the last write time (modification date and time)
    local command = 'powershell -command "(Get-Item \'' .. file .. '\').LastWriteTime.ToString(\'HH:mm:ss\')"'

    -- Execute the PowerShell command and capture the output
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    -- Trim the result to remove extra whitespace
    result = result:gsub("\n", ""):gsub("\r", ""):match("^%s*(.-)%s*$")
    result = result:match("^(%d+:%d+)") -- Extract only hours and minutes

    return result
end

-- Access the Fusion composition
fusion = bmd.scriptapp("Fusion")
comp = fusion:GetCurrentComp()

-- Find the MediaIn node
media_in = comp:FindTool("MediaIn1")

if media_in then
    -- Get the clip path from the MediaIn node's attributes
    local clip_path = media_in:GetAttrs().TOOLS_Clip_Path

    -- local attributes = media_in:GetAttrs()

    -- Print all attributes
    -- print("Attributes of MediaIn1:")
    -- for key, value in pairs(attributes) do
    --     print(key, ":", value)
    -- end

    -- Check if the file exists
    local file = io.open(clip_path, "r")
    if file then
        io.close(file)

        -- Get the file's creation or modification time
        local creation_time = get_file_modification_time(clip_path)

        -- Find the Text+ node
        local text_node = comp:FindTool("Text1") -- Make sure your Text+ node is named 'Text1'

        if text_node then
            -- Update the Text+ node with the creation time
            text_node.StyledText = "".. creation_time
            print("Updated Text+ node with time: " .. creation_time)
        else
            print("Text+ node not found. Make sure it's named 'Text1'.")
        end
    else
        print("Clip path not found or file does not exist.")
    end
else
    print("MediaIn node not found.")
end

