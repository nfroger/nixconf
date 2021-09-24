final: prev: {
  nixUnstable = prev.nixUnstable.overrideAttrs (oldAttrs: oldAttrs // {
    patches = [ ./unset-is-macho.patch ];
    meta = (oldAttrs.meta or { }) // {
      priority = 10;
    };
  });
}
