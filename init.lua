enduser_setup.start(
  function()
    print("Connected to WiFi as:" .. wifi.sta.getip())
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end,
  print -- Lua print function can serve as the debug callback
)

enduser_setup.stop()

srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
  conn:on("receive", function(conn, received_data)
    print(received_data)
    output_data = [[{
      "rejection": "I don't know what to tell you, pal. I'm a teapot with a hole in it.",
      "emoji": "🫖 🧡"
    }]]
    local responseHeaders = {
      ["Content-Type"] = "application/json; charset=utf-8",
      ["Connection"] = "close",
      ["Content-Length"] = string.len(output_data),
      ["Safe"] = "Safe"
    }
    endResponse(conn, 418, "I'm a teapot", responseHeaders, output_data)

  end)
end)

function endResponse(conn, statusCode, statusMessage, headers, data)
  conn:send("HTTP/1.1 " .. statusCode .. " " .. statusMessage .. "\r\n")
  if headers then
      for k, v in pairs(headers) do conn:send(k .. ": " .. v .. "\r\n") end
  end
  conn:send("\r\n")
  if data then conn:send(data) end
  conn:on("sent", function(s) s:close() end)
end