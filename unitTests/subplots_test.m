function [passed, msg] = subplots_test()

try
    [isSame, ~] = checkPlots(@subplots);
catch e
    passed = false;
    msg = sprintf('Expected false; got exception %s', e.identifier);
    return;
end
if isSame
    passed = false;
    msg = 'Expected false; got true';
    return;
end
passed = true;
msg = '';
end