lib.callback.register('king-drugs:server:haveLaundryItem', function(src, item)
    return FMFunctions.GetPlayersItemAmont(src, item) > 0;
end)