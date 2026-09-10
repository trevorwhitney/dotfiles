export const SupersetNotifyInstanceReset = async () => {
  delete globalThis.__supersetOpencodeNotifyPluginV10;
  return {};
};
