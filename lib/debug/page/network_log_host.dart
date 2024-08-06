import 'dart:io';

import 'package:ext_library/log_util.dart';
import 'package:ext_library/tool/extensions/function_ext.dart';
import 'package:ext_library/tool/extensions/string_ext.dart';
import 'package:ext_library/tool/extensions/text_editing_ext.dart';
import 'package:ext_library/tool/tool_lib.dart';
import 'package:ext_library/ui/toast/toast.dart';
import 'package:flutter/material.dart';

/// 网络设置相关
class NetworkLogHostPage extends StatefulWidget {
  Uri? baseUri;
  String? appConfig;
  Function(Uri uri)? onChange;
  Function(String url)? toWebView;
  VoidCallback? doRelease;
  VoidCallback? doDevelop;
  NetworkLogHostPage({
    Key? key,
    this.baseUri,
    this.appConfig,
    this.onChange,
    this.toWebView,
    this.doRelease,
    this.doDevelop,
  }) : super(key: key);

  @override
  _NetworkLogHostPageState createState() => _NetworkLogHostPageState();
}

class _NetworkLogHostPageState extends State<NetworkLogHostPage> {
  late final TextEditingController _domainController;
  late final TextEditingController _webController;

  Uri? currUri;

  @override
  void initState() {
    super.initState();
    if (widget.baseUri != null) {
      currUri = widget.baseUri;
    }
    _domainController = TextEditingController(text: 'http://');
    _webController = TextEditingController(text: 'https://www.baidu.com');
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _domainController.dispose();
    _webController.dispose();
    super.dispose();
  }

  Future<void> setUrl(String url) async {
    if (widget.onChange != null) {
      widget.onChange!(Uri.parse(url));
    }
  }

  void reStart() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      children: <Widget>[
        _buildInputHost(
          currUrl: '当前域名：${currUri?.origin}',
          controller: _domainController,
          hintText: '请输入新域名: scheme://host:port',
          onTap: () async {
            final newUri = Uri.tryParse(_domainController.text);
            final isHttpUrl = newUri != null &&
                newUri.scheme.startsWith(RegExp('^[https|http]'));
            if (newUri != null && isHttpUrl && !newUri.host.isnull) {
              await setUrl(newUri.origin);
            } else {
              AppToast.showText('Url格式错误');
            }
          },
        ),
        _buildFastSwitch(),
        const SizedBox(height: 10),
        _buildInputUrl(),
        const SizedBox(height: 40),
        _buildUriItem(des: '正式', uri: 'https://api.washine.app'),
        _buildUriItem(des: '预发布', uri: 'http://pre'),
        _buildUriItem(des: '测试', uri: 'https://dev.wapen.app'),
        const SizedBox(height: 40),
        Text(
          '当前Config:\n${widget.appConfig ?? widget.baseUri.toString().fixLines}',
          style: TextStyle(color: Colors.green),
          maxLines: 99,
        )
      ],
    );
  }

  Widget _buildInputUrl() {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _webController,
              keyboardType: TextInputType.url,
              style: TextStyle(),
              decoration: InputDecoration(
                hintText: '输入web地址',
                hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5), fontSize: 12),
                suffixIcon: InkWell(
                  onTap: () {
                    _webController.input('');
                    setState(() {});
                  },
                  child: const Icon(Icons.close, size: 18),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              print('msg====  ${_webController.text}');
              final isHttpUrl = !_webController.text.isnull &&
                  _webController.text.startsWith(RegExp('^[https|http]'));
              if (isHttpUrl) {
                if (widget.toWebView != null) {
                  widget.toWebView!(_webController.text);
                }
              } else {
                AppToast.showText(' Web Url格式错误');
              }
            }.keyBoard(),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            child: Text('进入Web', style: TextStyle()),
          ),
        ],
      ),
    );
  }

  Widget _buildInputHost({
    required TextEditingController controller,
    String? currUrl,
    String? hintText,
    VoidCallback? onTap,
  }) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            currUrl ?? '',
            style: const TextStyle(color: Colors.lightBlue, fontSize: 20),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 17),
            suffixIcon: InkWell(
              onTap: () {
                controller.input('');
                setState(() {});
              },
              child: const Icon(Icons.close, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onTap,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
            ),
            child: const Text('确定修改域名'),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFastSwitch() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              if (widget.doRelease != null) {
                widget.doRelease!();
              }
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            child: const Text('切换Release'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextButton(
            onPressed: () {
              if (widget.doDevelop != null) {
                widget.doDevelop!();
              }
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
            ),
            child: const Text('切换到Test'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextButton(
            onPressed: () => reStart(),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text('重启APP'),
          ),
        ),
      ],
    );
  }

  Widget _buildUriItem({String? des, String? uri}) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$des : ',
              style: const TextStyle(color: Colors.lightBlue),
            ),
          ),
          Text(
            uri ?? 'null',
            style: const TextStyle(color: Colors.red),
          ),
          const Spacer(),
          InkWell(
            onTap: () => LibTools.copy(uri),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.blue),
              child: const Text('copy', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}

class EnvAlertDialog extends StatelessWidget {
  final String? title;
  final bool withCancel;
  const EnvAlertDialog({Key? key, this.title, this.withCancel = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.only(top: 10),
            child: Text(title ?? '', style: TextStyle(color: Colors.red)),
          ),
          Expanded(
            child: withCancel
                ? Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                          ),
                          child: const Text('确定'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                          ),
                          child: const Text('取消'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text('确定'),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
